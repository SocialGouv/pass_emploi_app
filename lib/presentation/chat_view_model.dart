import 'package:collection/collection.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

import 'chat_item.dart';

class ChatViewModel {
  final String title;
  final bool withLoading;
  final bool withFailure;
  final bool withContent;
  final List<ChatItem> items;
  final Function(String message) onSendMessage;

  ChatViewModel({
    required this.title,
    required this.withLoading,
    required this.withFailure,
    required this.withContent,
    required this.items,
    required this.onSendMessage,
  });

  factory ChatViewModel.create(Store<AppState> store) {
    final chatState = store.state.chatState;
    final userActionState = store.state.userActionState;
    return ChatViewModel(
      title: userActionState is UserActionSuccessState
          ? "Discuter avec ${userActionState.home.conseiller.firstName}"
          : "Votre conseiller",
      withLoading: chatState is ChatLoadingState,
      withFailure: chatState is ChatFailureState,
      withContent: chatState is ChatSuccessState,
      items: chatState is ChatSuccessState ? _messagesToChatItems(chatState.messages) : [],
      onSendMessage: (String message) => store.dispatch(SendMessageAction(message)),
    );
  }
}

_messagesToChatItems(List<Message> messages) {
  return _messagesWithDaySections(messages).map<ChatItem>((element) {
    if (element is String) {
      return DayItem(element);
    } else {
      final message = element as Message;
      final hourLabel = 'à ' + message.creationDate.toHour();
      if (message.sentBy == Sender.jeune) return JeuneMessageItem(message.content, hourLabel);
      return ConseillerMessageItem(message.content, hourLabel);
    }
  }).toList();
}

_messagesWithDaySections(List<Message> messages) {
  final messagesWithDaySections = <dynamic>[];
  groupBy(messages, (message) => _getDayLabel((message as Message).creationDate)).forEach((day, messagesOfDay) {
    messagesWithDaySections.add(day);
    messagesWithDaySections.addAll(messagesOfDay);
  });
  return messagesWithDaySections;
}

_getDayLabel(DateTime dateTime) => dateTime.isAtSameDayAs(DateTime.now()) ? "Aujourd'hui" : 'Le ' + dateTime.toDay();
