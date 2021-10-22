import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';

AppState uiActionReducer(AppState currentState, dynamic action) {
  if (action is UpdateActionStatus) {
    final currentActionState = currentState.userActionState;
    if (currentActionState is UserActionSuccessState) {
      return _checkIfUpdateActionStatusNeeded(
        currentState,
        currentActions: currentActionState.actions,
        updateActionStatus: action,
      );
    } else {
      return currentState;
    }
  } else if (action is DismissUserActionUpdated) {
    return _dismissUserActionUpdated(currentState);
  } else {
    return currentState;
  }
}

AppState _checkIfUpdateActionStatusNeeded(AppState currentState,
    {required List<UserAction> currentActions, required UpdateActionStatus updateActionStatus}) {
  final actionToUpdate = currentActions.firstWhere((a) => a.id == updateActionStatus.actionId);
  if (actionToUpdate.status == updateActionStatus.newStatus) {
    return currentState.copyWith(
      userActionUpdateState: UserActionUpdateState.noUpdateNeeded(),
    );
  } else {
    return _updateActionStatus(actionToUpdate, updateActionStatus, currentActions, currentState);
  }
}

AppState _updateActionStatus(
  UserAction actionToUpdate,
  UpdateActionStatus updateActionStatus,
  List<UserAction> currentActions,
  AppState currentState,
) {
  final updatedAction = UserAction(
    id: actionToUpdate.id,
    content: actionToUpdate.content,
    comment: actionToUpdate.comment,
    status: updateActionStatus.newStatus,
    lastUpdate: DateTime.now(),
    creator: actionToUpdate.creator,
  );
  final newActions = List<UserAction>.from(currentActions).where((a) => a.id != updateActionStatus.actionId).toList()
    ..add(updatedAction);
  return currentState.copyWith(
    userActionState: UserActionState.success(newActions),
    userActionUpdateState: UserActionUpdateState.updated(),
  );
}

AppState _dismissUserActionUpdated(AppState currentState) {
  return currentState.copyWith(
    userActionUpdateState: UserActionUpdateState.notUpdating(),
  );
}