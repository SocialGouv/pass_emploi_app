import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';

UserActionDeleteState userActionDeleteReducer(UserActionDeleteState current, dynamic action) {
  if (action is UserActionDeleteLoadingAction) return UserActionDeleteLoadingState();
  if (action is UserActionDeleteFailureAction) return UserActionDeleteFailureState();
  if (action is UserActionDeleteSuccessAction) return UserActionDeleteSuccessState();
  if (action is UserActionDeleteResetAction) return UserActionDeleteNotInitializedState();
  return current;
}
