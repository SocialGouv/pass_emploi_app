import 'package:collection/collection.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

import 'chat_item.dart';

class ChatViewModel {
  final bool withLoading;
  final bool withFailure;
  final bool withContent;
  final List<ChatItem> items;

  ChatViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.withContent,
    required this.items,
  });

  factory ChatViewModel.create(Store<AppState> store) {
    final state = store.state.chatState;
    return ChatViewModel(
        withLoading: state is ChatLoadingState,
        withFailure: state is ChatFailureState,
        withContent: state is ChatSuccessState,
        items: state is ChatSuccessState ? _messagesToChatItems(state.messages) : []);
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
