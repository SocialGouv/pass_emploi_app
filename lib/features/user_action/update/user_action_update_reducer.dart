import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';

UserActionUpdateState userActionUpdateReducer(UserActionUpdateState current, dynamic action) {
  if (action is UserActionUpdateResetAction) return UserActionUpdateNotInitializedState();
  if (action is UserActionUpdateLoadingAction) return UserActionUpdateLoadingState();
  if (action is UserActionUpdateSuccessAction) return UserActionUpdateSuccessState(action.request);
  if (action is UserActionUpdateFailureAction) return UserActionUpdateFailureState();
  return current;
}
