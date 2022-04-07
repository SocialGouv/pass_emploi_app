import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionDeleteMiddleware extends MiddlewareClass<AppState> {
  final UserActionRepository _repository;

  UserActionDeleteMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is UserActionDeleteRequestAction) {
      store.dispatch(UserActionDeleteLoadingAction());
      final result = await _repository.deleteUserAction(action.actionId);
      store.dispatch(result ? UserActionDeleteSuccessAction(action.actionId) : UserActionDeleteFailureAction());
    }
  }
}
