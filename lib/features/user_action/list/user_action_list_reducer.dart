import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';

UserActionListState userActionListReducer(UserActionListState current, dynamic action) {
  if (action is UserActionListLoadingAction) return UserActionListLoadingState();
  if (action is UserActionListFailureAction) return UserActionListFailureState();
  if (action is UserActionListSuccessAction) return UserActionListSuccessState(action.userActions, action.campagne);
  if (action is UserActionListResetAction) return UserActionListNotInitializedState();
  if (action is UserActionDeleteSuccessAction && current is UserActionListSuccessState) {
    return UserActionListSuccessState(
      current.userActions.where((e) => e.id != action.actionId).toList(),
      current.campagne,
    );
  }
  if (action is UserActionUpdateRequestAction && current is UserActionListSuccessState) {
    final currentActions = current.userActions;
    final actionToUpdate = currentActions.firstWhere((a) => a.id == action.actionId);
    final updatedAction = UserAction(
      id: actionToUpdate.id,
      content: actionToUpdate.content,
      comment: actionToUpdate.comment,
      status: action.newStatus,
      lastUpdate: DateTime.now(),
      creator: actionToUpdate.creator,
    );
    final newActions = List<UserAction>.from(currentActions).where((a) => a.id != action.actionId).toList()
      ..insert(0, updatedAction);
    return UserActionListSuccessState(newActions, current.campagne);
  }
  return current;
}
