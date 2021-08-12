import 'package:intl/intl.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:redux/redux.dart';

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

List<ChatItem> _messagesToChatItems(List<Message> messages) {
  final messagesWithDaySections = _messagesWithDaySections(messages);
  return messagesWithDaySections.map<ChatItem>((element) {
    if (element is String) {
      return DayItem(element);
    } else {
      final message = element as Message;
      final DateFormat formatter = DateFormat('à HH:mm');
      final hourLabel = formatter.format(message.creationDate);
      if (message.sentBy == Sender.jeune) return JeuneMessageItem(message.content, hourLabel);
      return ConseillerMessageItem(message.content, hourLabel);
    }
  }).toList();
}

_messagesWithDaySections(List<Message> messages) {
  final days = messages
      .map((message) {
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        return 'Le ' + formatter.format(message.creationDate);
      })
      .toSet()
      .toList();

  final messagesWithDaySections = <dynamic>[];

  for (var indexOfDay = 0; indexOfDay < days.length; indexOfDay++) {
    messagesWithDaySections.add(days[indexOfDay]);
    final messageOfDay = messages.where((message) {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final messageDay = 'Le ' + formatter.format(message.creationDate);
      return messageDay == days[indexOfDay];
    }).toList();
    messagesWithDaySections.addAll(messageOfDay);
  }
  return messagesWithDaySections;
}

abstract class ChatItem {}

class DayItem extends ChatItem {
  final String dayLabel;

  DayItem(this.dayLabel);
}

abstract class MessageItem extends ChatItem {
  final String content;
  final String hourLabel;

  MessageItem(this.content, this.hourLabel);
}

class JeuneMessageItem extends MessageItem {
  JeuneMessageItem(String content, String hour) : super(content, hour);
}

class ConseillerMessageItem extends MessageItem {
  ConseillerMessageItem(String content, String hour) : super(content, hour);
}
