import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_state.dart';

UserActionCreatePendingState userActionCreatePendingReducer(UserActionCreatePendingState current, dynamic action) {
  if (action is UserActionCreatePendingAction) return UserActionCreatePendingSuccessState(action.pendingCreationsCount);
  return current;
}
