import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

class RouterMiddleware extends MiddlewareClass<AppState> {
  final UserRepository repository; // TODO-115 remove ?
  final Authenticator _authenticator;

  RouterMiddleware(this.repository, this._authenticator);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction) {
      _checkIfUserIsLoggedIn(store);
    } else if (action is LoggedInAction) {
      store.dispatch(RequestHomeAction(action.user.id));
    } else if (action is RequestLoginActionV2) {
      _logUser(store);
    } else if (action is LogoutAction) {
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
    if (await _authenticator.login() != null) {
      _dispatchLoggedInAction(store);
    } else {
      store.dispatch(NotLoggedInAction());
    }
  }

  void _dispatchLoggedInAction(Store<AppState> store) {
    final AuthIdToken idToken = _authenticator.idToken()!;
    // TODO-115 : hardcoded user ID until backend route is not merged
    //final user = User(id: idToken.userId, firstName: idToken.firstName, lastName: idToken.lastName);
    final user = User(id: "KAYUF", firstName: idToken.firstName, lastName: idToken.lastName);
    // TODO-115: required to init chat on server side. Ask later to backend team if we wan remove it. Await required?
    repository.logUser(user.id);
    store.dispatch(LoggedInAction(user));
  }

  void _logout(Store<AppState> store) async {
    await repository.deleteUser();
    store.dispatch(BootstrapAction());
  }
}
