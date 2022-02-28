import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionDeleteMiddleware extends MiddlewareClass<AppState> {
  final UserActionRepository _repository;

  UserActionDeleteMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is UserActionDeleteRequestAction) {
      store.dispatch(UserActionDeleteLoadingAction());
      final result = await _repository.deleteUserAction(action.actionId);
      store.dispatch(result ? UserActionDeleteSuccessAction(action.actionId) : UserActionDeleteFailureAction());
    }
  }
}
