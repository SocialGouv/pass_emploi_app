import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_state.dart';

UserActionPEListState userActionPEListReducer(UserActionPEListState current, dynamic action) {
  if (action is UserActionPEListLoadingAction) return UserActionPEListLoadingState();
  if (action is UserActionPEListFailureAction) return UserActionPEListFailureState();
  if (action is UserActionPEListSuccessAction) return UserActionPEListSuccessState(action.userActions, action.campagne);
  if (action is UserActionPEListResetAction) return UserActionPEListNotInitializedState();
  return current;
}