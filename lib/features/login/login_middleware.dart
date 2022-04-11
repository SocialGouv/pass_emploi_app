import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class LoginMiddleware extends MiddlewareClass<AppState> {
  final Authenticator _authenticator;
  final FirebaseAuthWrapper _firebaseAuthWrapper;
  final ModeDemoRepository _modeDemoRepository;

  LoginMiddleware(this._authenticator, this._firebaseAuthWrapper, this._modeDemoRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction) {
      _checkIfUserIsLoggedIn(store);
    } else if (action is RequestLoginAction) {
      _logUser(store, action.mode);
    } else if (action is RequestLogoutAction) {
      _logout(store);
    }
  }

  void _checkIfUserIsLoggedIn(Store<AppState> store) async {
    if (await _authenticator.isLoggedIn()) {
      _dispatchLoginSuccess(store);
    } else {
      store.dispatch(NotLoggedInAction());
    }
  }

  void _logUser(Store<AppState> store, RequestLoginMode mode) async {
    store.dispatch(LoginLoadingAction());
    if (mode == RequestLoginMode.DEMO) {
      _modeDemoRepository.setModeDemo(true);
      final user = User(
        id: "token de demo",
        firstName: "Super Lana",
        lastName: "2",
        email: "mode@demo.com",
        loginMode: LoginMode.DEMO,
      );
      store.dispatch(LoginSuccessAction(user));
    } else {
      _modeDemoRepository.setModeDemo(false);
      final authenticatorResponse = await _authenticator.login(_getAuthenticationMode(mode));
      if (authenticatorResponse == AuthenticatorResponse.SUCCESS) {
        _dispatchLoginSuccess(store);
      } else if (authenticatorResponse == AuthenticatorResponse.FAILURE) {
        store.dispatch(LoginFailureAction());
      } else {
        store.dispatch(NotLoggedInAction());
      }
    }
  }

  void _dispatchLoginSuccess(Store<AppState> store) async {
    final AuthIdToken idToken = (await _authenticator.idToken())!;
    final user = User(
      id: idToken.userId,
      firstName: idToken.firstName,
      lastName: idToken.lastName,
      email: idToken.email,
      loginMode: idToken.getLoginMode(),
    );
    store.dispatch(LoginSuccessAction(user));
  }

  void _logout(Store<AppState> store) async {
    await _authenticator.logout();
    store.dispatch(UnsubscribeFromChatStatusAction());
    store.dispatch(BootstrapAction());
    _firebaseAuthWrapper.signOut();
  }

  AuthenticationMode _getAuthenticationMode(RequestLoginMode mode) {
    switch (mode) {
      case RequestLoginMode.PASS_EMPLOI:
        return AuthenticationMode.GENERIC;
      case RequestLoginMode.SIMILO:
        return AuthenticationMode.SIMILO;
      case RequestLoginMode.POLE_EMPLOI:
        return AuthenticationMode.POLE_EMPLOI;
      case RequestLoginMode.DEMO:
        return AuthenticationMode.DEMO;
    }
  }
}
