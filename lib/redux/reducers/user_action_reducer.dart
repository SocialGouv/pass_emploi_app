import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/create_user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_delete_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';

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
