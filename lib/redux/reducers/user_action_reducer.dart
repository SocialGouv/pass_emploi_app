import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/create_user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_delete_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';

AppState userActionReducer(AppState currentState, dynamic action) {
  if (action is UserActionLoadingAction) {
    return currentState.copyWith(userActionState: UserActionState.loading());
  } else if (action is UserActionSuccessAction) {
    return currentState.copyWith(userActionState: UserActionState.success(action.actions));
  } else if (action is UserActionFailureAction) {
    return currentState.copyWith(userActionState: UserActionState.failure());
  } else if (action is UserActionCreatedWithSuccessAction) {
    return currentState.copyWith(createUserActionState: CreateUserActionState.success());
  } else if (action is UserActionCreationFailed) {
    return currentState.copyWith(createUserActionState: CreateUserActionState.error());
  } else if (action is UserActionDeleteLoadingAction) {
    return currentState.copyWith(userActionDeleteState: UserActionDeleteState.loading());
  } else if (action is UserActionDeleteSuccessAction) {
    final previousUserActionState = currentState.userActionState;
    if (previousUserActionState is UserActionSuccessState) {
      return currentState.copyWith(
          userActionDeleteState: UserActionDeleteState.success(),
          userActionState: _removeDeletedUserAction(previousUserActionState, action));
    } else {
      return currentState;
    }
  } else if (action is UserActionDeleteFailureAction) {
    return currentState.copyWith(userActionDeleteState: UserActionDeleteState.failure());
  } else if (action is UserActionUpdateStatusAction) {
    final currentActionState = currentState.userActionState;
    if (currentActionState is UserActionSuccessState) {
      final currentActions = currentActionState.actions;
      final actionToUpdate = currentActions.firstWhere((a) => a.id == action.actionId);
      return _updateActionStatus(actionToUpdate, action, currentActions, currentState);
    } else {
      return currentState;
    }
  } else if (action is DismissUserActionDetailsAction) {
    return _dismissUserActionDetailsAction(currentState);
  } else if (action is DismissCreateUserAction) {
    return _dismissCreateUserAction(currentState);
  } else if (action is UserActionNoUpdateNeededAction) {
    return _noUpdateNeededActionUpdate(currentState);
  } else if (action is CreateUserAction) {
    return currentState.copyWith(createUserActionState: CreateUserActionState.loading());
  } else {
    return currentState;
  }
}

UserActionSuccessState _removeDeletedUserAction(
  UserActionSuccessState previousUserActionState,
  UserActionDeleteSuccessAction action,
) {
  return UserActionSuccessState(
    previousUserActionState.actions.where((element) => element.id != action.actionId).toList(),
  );
}

AppState _updateActionStatus(
  UserAction actionToUpdate,
  UserActionUpdateStatusAction updateActionStatus,
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

AppState _dismissUserActionDetailsAction(AppState currentState) {
  return currentState.copyWith(
    userActionUpdateState: UserActionUpdateState.notUpdating(),
    userActionDeleteState: UserActionDeleteState.notInitialized(),
  );
}

AppState _noUpdateNeededActionUpdate(AppState currentState) {
  return currentState.copyWith(
    userActionUpdateState: UserActionUpdateState.noUpdateNeeded(),
  );
}

AppState _dismissCreateUserAction(AppState currentState) {
  return currentState.copyWith(
    createUserActionState: CreateUserActionState.notInitialized(),
  );
}
