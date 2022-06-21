import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class ChatPageViewModel extends Equatable {
  final DisplayState displayState;
  final String? brouillon;
  final List<ChatItem> items;
  final Function(String message) saveBrouillon;
  final Function(String message) onSendMessage;
  final Function() onRetry;

  ChatPageViewModel({
    required this.displayState,
    required this.brouillon,
    required this.items,
    required this.saveBrouillon,
    required this.onSendMessage,
    required this.onRetry,
  });

  factory ChatPageViewModel.create(Store<AppState> store) {
    final chatState = store.state.chatState;
    final statusState = store.state.chatStatusState;
    final lastReading = (statusState is ChatStatusSuccessState) ? statusState.lastConseillerReading : minDateTime;
    return ChatPageViewModel(
      displayState: _displayState(chatState),
      brouillon: store.state.chatBrouillonState.message,
      items: chatState is ChatSuccessState ? _messagesToChatItems(chatState.messages, lastReading) : [],
      saveBrouillon: (String message) => store.dispatch(SaveChatBrouillonAction(message)), // todo inutile maintenant ? (c'est dans le ondispose et plus dans le widget)
      onSendMessage: (String message) => store.dispatch(SendMessageAction(message)), // todo peut-être besoin de clear le brouillon ? OU dans brouillonReducer, intercepter SendMessageAction pour clear
      onRetry: () => store.dispatch(SubscribeToChatAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, brouillon, items];
}

DisplayState _displayState(ChatState state) {
  if (state is ChatLoadingState) return DisplayState.LOADING;
  if (state is ChatFailureState) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}

List<ChatItem> _messagesToChatItems(List<Message> messages, DateTime lastConseillerReading) {
  return _messagesWithDaySections(messages).map<ChatItem>((element) {
    if (element is String) {
      return DayItem(element);
    } else {
      final message = element as Message;
      switch (message.type) {
        case MessageType.message:
          return _buildMessageItem(message, lastConseillerReading);
        case MessageType.nouveauConseiller:
          return InformationItem(Strings.newConseillerTitle, Strings.newConseillerDescription);
        case MessageType.nouveauConseillerTemporaire:
          return InformationItem(Strings.newConseillerTemporaireTitle, Strings.newConseillerDescription);
        case MessageType.messagePj:
          return _pieceJointeItem(message);
        case MessageType.inconnu:
          return InformationItem(Strings.unknownTypeTitle, Strings.unknownTypeDescription);
      }
    }
  }).toList();
}

ChatItem _pieceJointeItem(Message message) {
  if (message.sentBy == Sender.conseiller) {
    return PieceJointeConseillerMessageItem(
      id: message.pieceJointes[0].id,
      message: message.content,
      filename: message.pieceJointes.first.nom,
      caption: message.creationDate.toHour(),
    );
  } else {
    return InformationItem(Strings.unknownTypeTitle, Strings.unknownTypeDescription);
  }
}

MessageItem _buildMessageItem(Message message, DateTime lastConseillerReading) {
  final hourLabel = message.creationDate.toHour();
  if (message.sentBy == Sender.jeune) {
    final redState = lastConseillerReading.isAfter(message.creationDate) ? Strings.read : Strings.sent;
    return JeuneMessageItem(content: message.content, caption: "$hourLabel · $redState");
  } else {
    return ConseillerMessageItem(content: message.content, caption: hourLabel);
  }
}

List<dynamic> _messagesWithDaySections(List<Message> messages) {
  final messagesWithDaySections = <dynamic>[];
  groupBy(messages, (message) => _getDayLabel((message as Message).creationDate)).forEach((day, messagesOfDay) {
    messagesWithDaySections.add(day);
    messagesWithDaySections.addAll(messagesOfDay);
  });
  return messagesWithDaySections;
}

String _getDayLabel(DateTime dateTime) {
  return dateTime.isAtSameDayAs(DateTime.now()) ? Strings.today : Strings.simpleDayFormat(dateTime.toDay());
}
