import 'package:pass_emploi_app/features/chat/partage/chat_partage_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';

ChatPartageState chatPartageReducer(ChatPartageState current, dynamic action) {
  if (action is ChatPartageLoadingAction) return ChatPartageState.loading;
  if (action is ChatPartageResetAction) return ChatPartageState.notInitialized;
  if (action is ChatPartageSuccessAction) return ChatPartageState.success;
  if (action is ChatPartageFailureAction) return ChatPartageState.failure;
  return current;
}