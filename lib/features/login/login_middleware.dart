import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_actions.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:redux/redux.dart';

class LoginMiddleware extends MiddlewareClass<AppState> {
  final Authenticator _authenticator;
  final FirebaseAuthWrapper _firebaseAuthWrapper;
  final ModeDemoRepository _modeDemoRepository;
  final PassEmploiMatomoTracker _matomoTracker;

  LoginMiddleware(this._authenticator, this._firebaseAuthWrapper, this._modeDemoRepository, this._matomoTracker);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    final userId = store.state.userId();
    next(action);
    if (action is BootstrapAction) {
      _checkIfUserIsLoggedIn(store);
    } else if (action is RequestLoginAction) {
      _logUser(store, action.mode);
    } else if (action is RequestLogoutAction) {
      _logout(store, userId, action.reason);
    }
  }

  void _checkIfUserIsLoggedIn(Store<AppState> store) async {
    if (await _authenticator.isLoggedIn()) {
      _dispatchLoginSuccess(store);
    } else {
      store.dispatch(NotLoggedInAction());
    }
  }

  void _logUser(Store<AppState> store, LoginMode mode) async {
    store.dispatch(LoginLoadingAction());
    store.dispatch(PreferredLoginModeSaveAction(loginMode: mode));
    if (mode.isDemo()) {
      _modeDemoRepository.setModeDemo(true);
      final user = _modeDemoUser(mode);
      store.dispatch(LoginSuccessAction(user));
      _matomoTracker.setOptOut(optOut: true);
    } else {
      _matomoTracker.setOptOut(optOut: false);
      _modeDemoRepository.setModeDemo(false);
      final authenticatorResponse = await _authenticator.login(_getAuthenticationMode(mode));
      if (authenticatorResponse is SuccessAuthenticatorResponse) {
        _dispatchLoginSuccess(store);
      } else if (authenticatorResponse is FailureAuthenticatorResponse) {
        store.dispatch(LoginFailureAction(authenticatorResponse.message));
      } else if (authenticatorResponse is WrongDeviceClockAuthenticatorResponse) {
        store.dispatch(LoginWrongDeviceClockAction());
      } else {
        store.dispatch(NotLoggedInAction());
      }
    }
  }

  User _modeDemoUser(LoginMode mode) {
    return User(
      id: "SEVP",
      firstName: "Paul",
      lastName: "Sevier",
      email: "mode@demo.com",
      loginMode: mode == LoginMode.DEMO_PE ? LoginMode.DEMO_PE : LoginMode.DEMO_MILO,
      accompagnement: Brand.isCej() ? Accompagnement.cej : Accompagnement.rsaFranceTravail,
    );
  }

  void _dispatchLoginSuccess(Store<AppState> store) async {
    final AuthIdToken idToken = (await _authenticator.idToken())!;
    final user = User(
      id: idToken.userId,
      firstName: idToken.firstName,
      lastName: idToken.lastName,
      email: idToken.email,
      loginMode: idToken.getLoginMode(),
      accompagnement: idToken.getAccompagnement(),
    );
    store.dispatch(LoginSuccessAction(user));
  }

  void _logout(Store<AppState> store, String? userId, LogoutReason reason) async {
    _matomoTracker.setOptOut(optOut: false);
    await _authenticator.logout(userId ?? 'NOT_LOGIN_USER', reason);
    store.dispatch(UnsubscribeFromChatStatusAction());
    store.dispatch(UnsubscribeFromConnectivityUpdatesAction());
    store.dispatch(BootstrapAction());
    _firebaseAuthWrapper.signOut();
  }

  AuthenticationMode _getAuthenticationMode(LoginMode mode) {
    return switch (mode) {
      LoginMode.MILO => AuthenticationMode.SIMILO,
      LoginMode.POLE_EMPLOI => AuthenticationMode.POLE_EMPLOI,
      LoginMode.DEMO_MILO => AuthenticationMode.DEMO,
      LoginMode.DEMO_PE => AuthenticationMode.DEMO,
    };
  }
}
