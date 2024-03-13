import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

ChatStatusState chatStatusReducer(ChatStatusState current, dynamic action) {
  if (action is ChatConseillerMessageAction) return _handleChatConseillerMessageAction(action, current);
  return current;
}

ChatStatusState _handleChatConseillerMessageAction(ChatConseillerMessageAction action, ChatStatusState current) {
  if (action.info.lastConseillerReading == null && !action.info.hasUnreadMessages) {
    return ChatStatusEmptyState();
  } else {
    return ChatStatusSuccessState(
      hasUnreadMessages: action.info.hasUnreadMessages,
      lastConseillerReading: action.info.lastConseillerReading ?? minDateTime,
    );
  }
}
