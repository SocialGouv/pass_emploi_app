import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';

UserActionUpdateState userActionUpdateReducer(UserActionUpdateState current, dynamic action) {
  if (action is UserActionNoUpdateNeededAction) return UserActionNoUpdateNeededState();
  if (action is UserActionUpdateResetAction) return UserActionNotUpdatingState();
  if (action is UserActionUpdateNeededAction) return UserActionUpdatedState(action.newStatus);
  if (action is UserActionNotUpdatingState) return UserActionNotUpdatingState(); // todo bizarre de dispatch un State :)
  return current;
}
