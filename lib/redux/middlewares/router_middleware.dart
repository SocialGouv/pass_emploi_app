import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

class RouterMiddleware extends MiddlewareClass<AppState> {
  final UserRepository repository;

  RouterMiddleware(this.repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is BootstrapAction) {
      _checkIfUserIsLoggedIn(store);
    } else if (action is LogoutAction) {
      _logout(store);
    }
  }

  void _checkIfUserIsLoggedIn(Store<AppState> store) async {
    // TODO-115 Check with authenticator if user is logged in
    // if logged in : convert AuthIdToken to User and forward action (tu devrais pouvoir garder le même dispatch)

    final user = await repository.getUser();
    store.dispatch(user != null ? LoggedInAction(user) : NotLoggedInAction());
  }

  void _logout(Store<AppState> store) async {
    await repository.deleteUser();
    store.dispatch(BootstrapAction());
  }
}
