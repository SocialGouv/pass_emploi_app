import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';

UserActionListState userActionListReducer(UserActionListState current, dynamic action) {
  if (action is UserActionListLoadingAction) return UserActionListLoadingState();
  if (action is UserActionListFailureAction) return UserActionListFailureState();
  if (action is UserActionListSuccessAction) return UserActionListSuccessState(action.userActions);
  if (action is UserActionListResetAction) return UserActionListNotInitializedState();
  if (action is UserActionDeleteSuccessAction) return _listWithDeletedAction(current, action);
  if (action is UserActionUpdateSuccessAction) return _listWithUpdatedAction(current, action);
  return current;
}

UserActionListState _listWithDeletedAction(UserActionListState current, UserActionDeleteSuccessAction action) {
  if (current is! UserActionListSuccessState) return current;
  return UserActionListSuccessState(current.userActions.where((e) => e.id != action.actionId).toList());
}

UserActionListState _listWithUpdatedAction(UserActionListState current, UserActionUpdateSuccessAction action) {
  if (current is! UserActionListSuccessState) return current;
  final newActions = current.userActions.withUpdatedAction(action.actionId, action.request);
  return UserActionListSuccessState(newActions);
}
