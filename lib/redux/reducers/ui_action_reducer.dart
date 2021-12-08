import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/create_user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_delete_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';

AppState uiActionReducer(AppState currentState, dynamic action) {
  if (action is DismissUserActionDetailsAction) {
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
