import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';

ChatState chatReducer(ChatState current, dynamic action) {
  if (action is ChatLoadingAction) return ChatLoadingState();
  if (action is ChatFailureAction) return ChatFailureState();
  if (action is ChatSuccessAction) return ChatSuccessState(action.messages);
  if (action is ChatResetAction) return ChatNotInitializedState();
  return current;
}
