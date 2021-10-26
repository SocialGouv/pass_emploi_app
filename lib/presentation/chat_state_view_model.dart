import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:redux/redux.dart';

class ChatStatusViewModel {
  final bool withUnreadMessages;
  final String unreadMessageCount;

  ChatStatusViewModel({
    required this.withUnreadMessages,
    required this.unreadMessageCount,
  });

  factory ChatStatusViewModel.create(Store<AppState> store) {
    final chatState = store.state.chatStatusState;
    final unreadMessages = chatState is ChatStatusSuccessState ? chatState.unreadMessageCount : 0;
    return ChatStatusViewModel(
      withUnreadMessages: unreadMessages > 0,
      unreadMessageCount: unreadMessages < 99 ? unreadMessages.toString() : '99',
    );
  }
}