import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';

UserActionCreateState userActionCreateReducer(UserActionCreateState current, dynamic action) {
  if (action is UserActionCreateLoadingAction) return UserActionCreateLoadingState();
  if (action is UserActionCreatePostponedAction) return UserActionCreatePostponedState();
  if (action is UserActionCreateSuccessAction) return UserActionCreateSuccessState(action.userActionCreatedId);
  if (action is UserActionCreateResetAction) return UserActionCreateNotInitializedState();
  return current;
}
