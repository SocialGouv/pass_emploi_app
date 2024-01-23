import 'package:pass_emploi_app/features/user_action/details/user_action_details_actions.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';

UserActionDetailsState userActionDetailsReducer(UserActionDetailsState current, dynamic action) {
  if (action is UserActionDetailsLoadingAction) return UserActionDetailsLoadingState();
  if (action is UserActionDetailsFailureAction) return UserActionDetailsFailureState();
  if (action is UserActionDetailsSuccessAction) return UserActionDetailsSuccessState(action.result);
  if (action is UserActionDetailsResetAction) return UserActionDetailsNotInitializedState();
  if (action is UserActionUpdateSuccessAction) return _detailsUpdated(current, action);
  return current;
}

UserActionDetailsState _detailsUpdated(UserActionDetailsState current, UserActionUpdateSuccessAction action) {
  if (current is! UserActionDetailsSuccessState) return current;
  if (current.result.id != action.actionId) return current;
  return UserActionDetailsSuccessState(current.result.copyWithRequest(action.request));
}
