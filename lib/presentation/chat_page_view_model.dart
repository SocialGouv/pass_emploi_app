import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

import '../ui/strings.dart';
import 'chat_item.dart';

class ChatPageViewModel {
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
    final homeState = store.state.homeState;
    final statusState = store.state.chatStatusState;
    final lastReading = (statusState is ChatStatusSuccessState) ? statusState.lastConseillerReading : minDateTime;
    return ChatPageViewModel(
      title: homeState is HomeSuccessState
          ? Strings.chatWith(homeState.home.conseiller.firstName)
          : Strings.yourConseiller,
      withLoading: chatState is ChatLoadingState,
      withFailure: chatState is ChatFailureState,
      withContent: chatState is ChatSuccessState,
      items: chatState is ChatSuccessState ? _messagesToChatItems(chatState.messages, lastReading) : [],
      onSendMessage: (String message) => store.dispatch(SendMessageAction(message)),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChatPageViewModel &&
            runtimeType == other.runtimeType &&
            title == other.title &&
            withLoading == other.withLoading &&
            withFailure == other.withFailure &&
            withContent == other.withContent &&
            listEquals(items, other.items);
  }

  @override
  int get hashCode {
    return title.hashCode ^ withLoading.hashCode ^ withFailure.hashCode ^ withContent.hashCode ^ items.hashCode;
  }
}

_messagesToChatItems(List<Message> messages, DateTime lastConseillerReading) {
  return _messagesWithDaySections(messages).map<ChatItem>((element) {
    if (element is String) {
      return DayItem(element);
    } else {
      final message = element as Message;
      final hourLabel = message.creationDate.toHour();
      if (message.sentBy == Sender.jeune) {
        final redState = lastConseillerReading.isAfter(message.creationDate) ? Strings.red : Strings.sent;
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
