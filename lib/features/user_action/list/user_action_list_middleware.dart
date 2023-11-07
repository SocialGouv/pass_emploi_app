import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionListMiddleware extends MiddlewareClass<AppState> {
  final UserActionRepository _repository;

  UserActionListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    // Need to be done before the action is dispatched to the reducer
    final int currentPendingActionsCount = store.state.userActionCreatePendingState.getPendingCreationsCount();

    next(action);

    final user = store.state.user();
    if (user == null) return;

    if (_needFetchingUserActionList(currentPendingActionsCount, action)) {
      store.dispatch(UserActionListLoadingAction());
      final page = await _repository.getPageActions(user.id);
      store.dispatch(page != null ? UserActionListSuccessAction(page.actions) : UserActionListFailureAction());
    }
  }
}

bool _needFetchingUserActionList(int currentPendingActionsCount, dynamic action) {
  return action is UserActionListRequestAction ||
      action is UserActionCreateSuccessAction ||
      _newUserActionsCreated(currentPendingActionsCount, action);
}

bool _newUserActionsCreated(int currentPendingActionsCount, dynamic action) {
  if (action is! UserActionCreatePendingAction) return false;
  return action.pendingCreationsCount < currentPendingActionsCount;
}
