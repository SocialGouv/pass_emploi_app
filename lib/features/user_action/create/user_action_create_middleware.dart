import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionCreateMiddleware extends MiddlewareClass<AppState> {
  final UserActionRepository _repository;

  UserActionCreateMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState.isSuccess() && action is UserActionCreateRequestAction) {
      store.dispatch(UserActionCreateLoadingAction());
      final result = await _repository.createUserAction(
        loginState.getResultOrThrow().id,
        action.content,
        action.comment,
        action.initialStatus,
      );
      if (result) {
        store.dispatch(UserActionCreateSuccessAction());
        store.dispatch(UserActionListRequestAction());
      } else {
        store.dispatch(UserActionCreateFailureAction());
      }
    }
  }
}
