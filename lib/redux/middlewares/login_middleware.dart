import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/bootstrap_action.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/firebase_auth_repository.dart';
import 'package:redux/redux.dart';

class LoginMiddleware extends MiddlewareClass<AppState> {
  final Authenticator _authenticator;
  final FirebaseAuthRepository _firebaseAuthRepository;
  final FirebaseAuthWrapper _firebaseAuthWrapper;

  LoginMiddleware(this._authenticator, this._firebaseAuthRepository, this._firebaseAuthWrapper);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction) {
      _checkIfUserIsLoggedIn(store);
    } else if (action is RequestLoginAction) {
      _logUser(store, action.mode);
    } else if (action is RequestLogoutAction) {
      _logout(store, action.logoutRequester);
      _firebaseAuthWrapper.signOut();
    } else if (action is LoginAction && action.isSuccess()) {
      _loginToFirebase(action.getResultOrThrow().id);
    }
  }

  void _checkIfUserIsLoggedIn(Store<AppState> store) async {
    if (_authenticator.isLoggedIn()) {
      _dispatchLoginSuccess(store);
    } else {
      store.dispatch(NotLoggedInAction());
    }
  }

  void _logUser(Store<AppState> store, RequestLoginMode mode) async {
    store.dispatch(LoginAction.loading());
    if (await _authenticator.login(_getAuthenticationMode(mode))) {
      _dispatchLoginSuccess(store);
    } else {
      store.dispatch(LoginAction.failure());
    }
  }

  void _dispatchLoginSuccess(Store<AppState> store) {
    final AuthIdToken idToken = _authenticator.idToken()!;
    final user = User(id: idToken.userId, firstName: idToken.firstName, lastName: idToken.lastName);
    store.dispatch(LoginAction.success(user));
  }

  void _logout(Store<AppState> store, LogoutRequester logoutRequester) async {
    if (logoutRequester == LogoutRequester.USER) await _authenticator.logout();
    store.dispatch(UnsubscribeFromChatStatusAction());
    return store.dispatch(BootstrapAction());
  }

  AuthenticationMode _getAuthenticationMode(RequestLoginMode mode) {
    switch (mode) {
      case RequestLoginMode.GENERIC:
        return AuthenticationMode.GENERIC;
      case RequestLoginMode.SIMILO:
        return AuthenticationMode.SIMILO;
    }
  }

  Future<void> _loginToFirebase(String userId) async {
    final token = await _firebaseAuthRepository.getFirebaseToken(userId);
    if (token != null) _firebaseAuthWrapper.signInWithCustomToken(token);
  }
}
