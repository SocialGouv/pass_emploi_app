import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';

AppState userActionReducer(AppState currentState, dynamic action) {
  if (action is UserActionLoadingAction) {
    return currentState.copyWith(userActionState: UserActionState.loading());
  } else if (action is UserActionSuccessAction) {
    return currentState.copyWith(userActionState: UserActionState.success(action.actions));
  } else if (action is UserActionFailureAction) {
    return currentState.copyWith(userActionState: UserActionState.failure());
  } else {
    return currentState;
  }
}
