import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/bootstrap_action.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class LoginMiddleware extends MiddlewareClass<AppState> {
  final Authenticator _authenticator;

  LoginMiddleware(this._authenticator);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction) {
      _checkIfUserIsLoggedIn(store);
    } else if (action is RequestLoginAction) {
      _logUser(store);
    } else if (action is RequestLogoutAction) {
      _logout(store);
    }
  }

  void _checkIfUserIsLoggedIn(Store<AppState> store) async {
    if (_authenticator.isLoggedIn()) {
      _dispatchLoggedInAction(store);
    } else {
      store.dispatch(NotLoggedInAction());
    }
  }

  void _logUser(Store<AppState> store) async {
    store.dispatch(LoginLoadingAction());
    if (await _authenticator.login(AuthenticationMode.GENERIC)) {
      _dispatchLoggedInAction(store);
    } else {
      store.dispatch(LoginFailureAction());
    }
  }

  void _dispatchLoggedInAction(Store<AppState> store) {
    final AuthIdToken idToken = _authenticator.idToken()!;
    final user = User(id: idToken.userId, firstName: idToken.firstName, lastName: idToken.lastName);
    store.dispatch(LoggedInAction(user));
  }

  void _logout(Store<AppState> store) async {
    store.dispatch(BootstrapAction());
  }
}
