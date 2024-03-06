import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class ChatPageViewModel extends Equatable {
  final DisplayState displayState;
  final String? brouillon;
  final List<ChatItem> items;
  final bool shouldShowOnboarding;
  final Function(String message) onSendMessage;
  final Function() onRetry;

  ChatPageViewModel({
    required this.displayState,
    required this.brouillon,
    required this.items,
    required this.shouldShowOnboarding,
    required this.onSendMessage,
    required this.onRetry,
  });

  factory ChatPageViewModel.create(Store<AppState> store) {
    final chatState = store.state.chatState;
    final statusState = store.state.chatStatusState;
    final lastReading = (statusState is ChatStatusSuccessState) ? statusState.lastConseillerReading : minDateTime;
    return ChatPageViewModel(
      displayState: _displayState(chatState),
      brouillon: store.state.chatBrouillonState.brouillon,
      items: chatState is ChatSuccessState ? _messagesToChatItems(chatState.messages, lastReading) : [],
      shouldShowOnboarding: _shouldShowOnboarding(store),
      onSendMessage: (String message) => store.dispatch(SendMessageAction(message)),
      onRetry: () => store.dispatch(SubscribeToChatAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, brouillon, items, shouldShowOnboarding];
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
        case MessageType.offre:
          return _offreMessageItem(message, lastConseillerReading);
        case MessageType.event:
          return _eventMessageItem(message, lastConseillerReading);
        case MessageType.evenementEmploi:
          return _evenementEmploiItem(message, lastConseillerReading);
        case MessageType.sessionMilo:
          return _sessionMiloItem(message, lastConseillerReading);
        case MessageType.inconnu:
          return InformationItem(Strings.unknownTypeTitle, Strings.unknownTypeDescription);
      }
    }
  }).toList();
}

ChatItem _sessionMiloItem(Message message, DateTime lastConseillerReading) {
  return SessionMiloMessageItem(
    messageId: message.id,
    content: message.content,
    idPartage: message.sessionMilo?.id ?? "",
    titrePartage: message.sessionMilo?.titre ?? "",
    sender: message.sentBy,
    caption: caption(message, lastConseillerReading),
    captionColor: _captionColor(message),
    shouldAnimate: _shouldAnimate(message),
  );
}

ChatItem _evenementEmploiItem(Message message, DateTime lastConseillerReading) {
  return EvenementEmploiMessageItem(
    messageId: message.id,
    content: message.content,
    idPartage: message.evenementEmploi?.id ?? "",
    titrePartage: message.evenementEmploi?.titre ?? "",
    sender: message.sentBy,
    caption: caption(message, lastConseillerReading),
    captionColor: _captionColor(message),
    shouldAnimate: _shouldAnimate(message),
  );
}

ChatItem _offreMessageItem(Message message, DateTime lastConseillerReading) {
  return OffreMessageItem(
    messageId: message.id,
    content: message.content,
    idPartage: message.offre?.id ?? "",
    titrePartage: message.offre?.titre ?? "",
    type: message.offre?.type ?? OffreType.inconnu,
    sender: message.sentBy,
    caption: caption(message, lastConseillerReading),
    captionColor: _captionColor(message),
    shouldAnimate: _shouldAnimate(message),
  );
}

ChatItem _eventMessageItem(Message message, DateTime lastConseillerReading) {
  return EventMessageItem(
    messageId: message.id,
    content: message.content,
    idPartage: message.event?.id ?? "",
    titrePartage: message.event?.titre ?? "",
    sender: message.sentBy,
    caption: caption(message, lastConseillerReading),
    captionColor: _captionColor(message),
    shouldAnimate: _shouldAnimate(message),
  );
}

ChatItem _pieceJointeItem(Message message) {
  if (message.sentBy == Sender.conseiller) {
    return PieceJointeConseillerMessageItem(
      messageId: message.id,
      pieceJointeId: message.pieceJointes[0].id,
      message: message.content,
      filename: message.pieceJointes.first.nom,
      caption: message.creationDate.toHour(),
      captionColor: _captionColor(message),
      shouldAnimate: _shouldAnimate(message),
    );
  } else {
    return InformationItem(Strings.unknownTypeTitle, Strings.unknownTypeDescription);
  }
}

Color? _captionColor(Message message) {
  return switch (message.status) {
    MessageStatus.sending => null,
    MessageStatus.sent => null,
    MessageStatus.failed => AppColors.warning,
  };
}

bool _shouldAnimate(Message message) {
  return switch (message.status) {
    MessageStatus.sending => true,
    _ => false,
  };
}

String caption(Message message, DateTime lastConseillerReading) {
  final hourLabel = message.creationDate.toHour();
  if (message.sentBy == Sender.jeune) {
    final status = switch (message.status) {
      MessageStatus.sending => Strings.sending,
      MessageStatus.sent => lastConseillerReading.isAfter(message.creationDate) ? Strings.read : Strings.sent,
      MessageStatus.failed => Strings.sendingFailed,
    };
    return "$hourLabel · $status";
  } else {
    return hourLabel;
  }
}

TextMessageItem _buildMessageItem(Message message, DateTime lastConseillerReading) {
  return TextMessageItem(
    messageId: message.id,
    content: message.content,
    caption: caption(message, lastConseillerReading),
    sender: message.sentBy,
    captionColor: _captionColor(message),
    shouldAnimate: _shouldAnimate(message),
  );
}

List<dynamic> _messagesWithDaySections(List<Message> messages) {
  final messagesWithDaySections = <dynamic>[];
  groupBy(messages, (message) => _getDayLabel(message.creationDate)).forEach((day, messagesOfDay) {
    messagesWithDaySections.add(day);
    messagesWithDaySections.addAll(messagesOfDay);
  });
  return messagesWithDaySections;
}

String _getDayLabel(DateTime dateTime) {
  return dateTime.isAtSameDayAs(DateTime.now()) ? Strings.today : Strings.simpleDayFormat(dateTime.toDay());
}

bool _shouldShowOnboarding(Store<AppState> store) {
 return store.state.onboardingState.showChatOnboarding;
}
