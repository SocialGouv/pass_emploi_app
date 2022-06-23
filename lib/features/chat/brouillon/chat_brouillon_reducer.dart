import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_actions.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_state.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';

ChatBrouillonState chatBrouillonReducer(ChatBrouillonState current, dynamic action) {
  if (action is SaveChatBrouillonAction) return ChatBrouillonState(action.message);
  if (action is SendMessageAction) return ChatBrouillonState(null);
  return current;
}