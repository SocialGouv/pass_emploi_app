import 'package:pass_emploi_app/features/chat/partage/chat_partage_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';

ChatPartageState chatPartageReducer(ChatPartageState current, dynamic action) {
  if (action is ChatPartageLoadingAction) return ChatPartageLoadingState();
  if (action is ChatPartageResetAction) return ChatPartageNotInitializedState();
  if (action is ChatPartageSuccessAction) return ChatPartageSuccessState();
  if (action is ChatPartageFailureAction) return ChatPartageFailureState();
  return current;
}
