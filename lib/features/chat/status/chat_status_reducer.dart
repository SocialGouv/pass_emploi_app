import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

ChatStatusState chatStatusReducer(ChatStatusState current, dynamic action) {
  if (action is ChatConseillerMessageAction) return _handleChatConseillerMessageAction(action, current);
  return current;
}

ChatStatusState _handleChatConseillerMessageAction(ChatConseillerMessageAction action, ChatStatusState current) {
  if (action.lastConseillerReading == null && action.unreadMessageCount == null) {
    return ChatStatusEmptyState();
  } else {
    return ChatStatusSuccessState(
      unreadMessageCount: action.unreadMessageCount != null ? action.unreadMessageCount! : 0,
      lastConseillerReading: action.lastConseillerReading != null ? action.lastConseillerReading! : minDateTime,
    );
  }
}
