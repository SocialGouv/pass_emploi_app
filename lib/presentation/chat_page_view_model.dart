import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

import '../ui/strings.dart';
import 'chat_item.dart';

class ChatPageViewModel extends Equatable {
  final String title;
  final bool withLoading;
  final bool withFailure;
  final bool withContent;
  final List<ChatItem> items;
  final Function(String message) onSendMessage;

  ChatPageViewModel({
    required this.title,
    required this.withLoading,
    required this.withFailure,
    required this.withContent,
    required this.items,
    required this.onSendMessage,
  });

  factory ChatPageViewModel.create(Store<AppState> store) {
    final chatState = store.state.chatState;
    final statusState = store.state.chatStatusState;
    final lastReading = (statusState is ChatStatusSuccessState) ? statusState.lastConseillerReading : minDateTime;
    return ChatPageViewModel(
      title: Strings.yourConseiller,
      withLoading: chatState is ChatLoadingState,
      withFailure: chatState is ChatFailureState,
      withContent: chatState is ChatSuccessState,
      items: chatState is ChatSuccessState ? _messagesToChatItems(chatState.messages, lastReading) : [],
      onSendMessage: (String message) => store.dispatch(SendMessageAction(message)),
    );
  }

  @override
  List<Object?> get props => [title, withLoading, withFailure, withContent, items];
}

_messagesToChatItems(List<Message> messages, DateTime lastConseillerReading) {
  return _messagesWithDaySections(messages).map<ChatItem>((element) {
    if (element is String) {
      return DayItem(element);
    } else {
      final message = element as Message;
      final hourLabel = message.creationDate.toHour();
      if (message.sentBy == Sender.jeune) {
        final redState = lastConseillerReading.isAfter(message.creationDate) ? Strings.read : Strings.sent;
        return JeuneMessageItem(content: message.content, caption: "$hourLabel · $redState");
      } else {
        return ConseillerMessageItem(content: message.content, caption: hourLabel);
      }
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

_getDayLabel(DateTime dateTime) =>
    dateTime.isAtSameDayAs(DateTime.now()) ? Strings.today : Strings.simpleDayFormat(dateTime.toDay());
