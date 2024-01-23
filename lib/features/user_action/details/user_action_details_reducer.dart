import 'package:pass_emploi_app/features/user_action/details/user_action_details_actions.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_state.dart';

UserActionDetailsState userActionDetailsReducer(UserActionDetailsState current, dynamic action) {
  if (action is UserActionDetailsLoadingAction) return UserActionDetailsLoadingState();
  if (action is UserActionDetailsFailureAction) return UserActionDetailsFailureState();
  if (action is UserActionDetailsSuccessAction) return UserActionDetailsSuccessState(action.result);
  if (action is UserActionDetailsResetAction) return UserActionDetailsNotInitializedState();
  return current;
}
