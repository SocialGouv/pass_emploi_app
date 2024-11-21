import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/message_important/message_important_state.dart';
import 'package:pass_emploi_app/features/tracking/tracking_evenement_engagement_action.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class ChatPageViewModel extends Equatable {
  final DisplayState displayState;
  final String? brouillon;
  final List<ChatItem> items;
  final String? messageImportant;
  final bool shouldShowOnboarding;
  final bool jeunePjEnabled;
  final Function(String message) onSendMessage;
  final Function(String imagePath) onSendImage;
  final Function(String filePath) onSendFile;
  final Function() onRetry;

  ChatPageViewModel({
    required this.displayState,
    required this.brouillon,
    required this.items,
    required this.messageImportant,
    required this.shouldShowOnboarding,
    required this.jeunePjEnabled,
    required this.onSendMessage,
    required this.onSendImage,
    required this.onSendFile,
    required this.onRetry,
  });

  factory ChatPageViewModel.create(Store<AppState> store, {bool releaseMode = true}) {
    final chatState = store.state.chatState;
    final statusState = store.state.chatStatusState;
    final lastReading = (statusState is ChatStatusSuccessState) ? statusState.lastConseillerReading : minDateTime;
    return ChatPageViewModel(
      displayState: _displayState(chatState),
      brouillon: store.state.chatBrouillonState.brouillon,
      items: chatState is ChatSuccessState ? _messagesToChatItems(chatState.messages, lastReading) : [],
      messageImportant: _messageImportant(store),
      shouldShowOnboarding: releaseMode && store.state.onboardingState.showChatOnboarding,
      jeunePjEnabled: store.state.isMiloLoginMode(),
      onSendMessage: (String message) => store.dispatch(SendMessageAction(message)),
      onSendImage: (String imagePath) => _sendImage(store, imagePath),
      onSendFile: (String filePath) => _sendFile(store, filePath),
      onRetry: () => store.dispatch(SubscribeToChatAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, brouillon, items, messageImportant, shouldShowOnboarding, jeunePjEnabled];
}

void _sendImage(Store<AppState> store, String imagePath) {
  store.dispatch(TrackingEvenementEngagementAction(EvenementEngagement.MESSAGE_ENVOYE_PJ));
  store.dispatch(SendImageAction(imagePath));
}

void _sendFile(Store<AppState> store, String filePath) {
  store.dispatch(TrackingEvenementEngagementAction(EvenementEngagement.MESSAGE_ENVOYE_PJ));
  store.dispatch(SendFileAction(filePath));
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

      if (message.contentStatus == MessageContentStatus.deleted) {
        return DeletedMessageItem(message.id, message.sentBy, Strings.chatDeletedMessage);
      }

      if (message.pieceJointes.firstOrNull?.analyseStatut == PieceJointeAnalyseStatut.expiree) {
        return DeletedMessageItem(message.id, message.sentBy, Strings.chatExpiredPjMessage);
      }

      return switch (message.type) {
        MessageType.message => _buildMessageItem(message, lastConseillerReading),
        MessageType.nouveauConseiller => InformationItem(Strings.newConseillerTitle, Strings.newConseillerDescription),
        MessageType.nouveauConseillerTemporaire => InformationItem(
            Strings.newConseillerTemporaireTitle,
            Strings.newConseillerDescription,
          ),
        MessageType.messagePj => _pieceJointeItem(message, lastConseillerReading),
        MessageType.localImagePj => _localImagePieceJointeItem(message),
        MessageType.localFilePj => _localFilePieceJointeItem(message),
        MessageType.offre => _offreMessageItem(message, lastConseillerReading),
        MessageType.event => _eventMessageItem(message, lastConseillerReading),
        MessageType.evenementEmploi => _evenementEmploiItem(message, lastConseillerReading),
        MessageType.sessionMilo => _sessionMiloItem(message, lastConseillerReading),
        MessageType.messageAction => _chatActionItem(message, lastConseillerReading),
        MessageType.inconnu => InformationItem(Strings.unknownTypeTitle, Strings.unknownTypeDescription)
      };
    }
  }).toList();
}

ChatItem _chatActionItem(Message message, DateTime lastConseillerReading) {
  return ActionMessageItem(
    messageId: message.id,
    content: message.content,
    sender: message.sentBy,
    caption: _caption(message, lastConseillerReading),
    captionColor: _captionColor(message),
    shouldAnimate: _shouldAnimate(message),
    idPartage: message.action?.id ?? "",
    titrePartage: message.action?.titre ?? "",
  );
}

ChatItem _sessionMiloItem(Message message, DateTime lastConseillerReading) {
  return SessionMiloMessageItem(
    messageId: message.id,
    content: message.content,
    idPartage: message.sessionMilo?.id ?? "",
    titrePartage: message.sessionMilo?.titre ?? "",
    sender: message.sentBy,
    caption: _caption(message, lastConseillerReading),
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
    caption: _caption(message, lastConseillerReading),
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
    caption: _caption(message, lastConseillerReading),
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
    caption: _caption(message, lastConseillerReading),
    captionColor: _captionColor(message),
    shouldAnimate: _shouldAnimate(message),
  );
}

ChatItem _pieceJointeItem(Message message, DateTime lastConseillerReading) {
  final isJeuneImage =
      message.pieceJointes.length == 1 && message.sentBy.isJeune && message.pieceJointes.first.nom.isImage();
  if (isJeuneImage) {
    return PieceJointeImageItem(
      messageId: message.id,
      pieceJointeId: message.pieceJointes[0].id,
      pieceJointeName: message.pieceJointes[0].nom,
      caption: _caption(message, lastConseillerReading),
      captionColor: _captionColor(message),
      shouldAnimate: _shouldAnimate(message),
    );
  }

  return PieceJointeMessageItem(
    sender: message.sentBy,
    messageId: message.id,
    pieceJointeId: message.pieceJointes[0].id,
    message: message.sentBy.isJeune ? null : message.content,
    filename: message.pieceJointes.first.nom,
    caption: _caption(message, lastConseillerReading),
    captionColor: _captionColor(message),
    shouldAnimate: _shouldAnimate(message),
  );
}

ChatItem _localImagePieceJointeItem(Message message) {
  return LocalImageMessageItem(
    messageId: message.id,
    imagePath: message.localPieceJointePath ?? "",
    showLoading: message.sendingStatus == MessageSendingStatus.sending,
    caption: _caption(message, minDateTime),
    captionSuffixIcon: message.sendingStatus == MessageSendingStatus.failed ? AppIcons.error_rounded : null,
    captionColor: _captionColor(message),
    shouldAnimate: _shouldAnimate(message),
  );
}

ChatItem _localFilePieceJointeItem(Message message) {
  return LocalFileMessageItem(
    messageId: message.id,
    fileName: message.localPieceJointePath?.split("/").last ?? "",
    showLoading: message.sendingStatus == MessageSendingStatus.sending,
    caption: _caption(message, minDateTime),
    captionSuffixIcon: message.sendingStatus == MessageSendingStatus.failed ? AppIcons.error_rounded : null,
    captionColor: _captionColor(message),
    shouldAnimate: _shouldAnimate(message),
  );
}

Color? _captionColor(Message message) {
  if ([PieceJointeAnalyseStatut.nonValide, PieceJointeAnalyseStatut.erreur]
      .contains(message.pieceJointes.firstOrNull?.analyseStatut)) {
    return AppColors.warning;
  }

  return switch (message.sendingStatus) {
    MessageSendingStatus.sending => null,
    MessageSendingStatus.sent => null,
    MessageSendingStatus.failed => AppColors.warning,
  };
}

bool _shouldAnimate(Message message) {
  return switch (message.sendingStatus) {
    MessageSendingStatus.sending => true,
    _ => false,
  };
}

String _caption(Message message, DateTime lastConseillerReading) {
  final hourLabel = message.creationDate.toHour();
  if (message.contentStatus == MessageContentStatus.edited) {
    return "$hourLabel · ${Strings.edited}";
  } else if (message.sentBy == Sender.jeune) {
    final String? pjStatut = switch (message.pieceJointes.firstOrNull?.analyseStatut) {
      PieceJointeAnalyseStatut.aFaire => Strings.sending,
      PieceJointeAnalyseStatut.enCours => Strings.sending,
      PieceJointeAnalyseStatut.valide => null,
      PieceJointeAnalyseStatut.nonValide => Strings.sendingFailed,
      PieceJointeAnalyseStatut.erreur => Strings.sendingFailed,
      PieceJointeAnalyseStatut.expiree => null,
      null => null,
    };

    final status = switch (message.sendingStatus) {
      MessageSendingStatus.sending => Strings.sending,
      MessageSendingStatus.sent => lastConseillerReading.isAfter(message.creationDate) ? Strings.read : Strings.sent,
      MessageSendingStatus.failed => Strings.sendingFailed,
    };
    return "$hourLabel · ${pjStatut ?? status}";
  } else {
    return hourLabel;
  }
}

TextMessageItem _buildMessageItem(Message message, DateTime lastConseillerReading) {
  return TextMessageItem(
    messageId: message.id,
    content: message.content,
    caption: _caption(message, lastConseillerReading),
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

String? _messageImportant(Store<AppState> store) {
  final chatState = store.state.messageImportantState;
  if (chatState is MessageImportantSuccessState) {
    final messageImportant = chatState.message;
    final now = DateTime.now();
    if ((messageImportant.dateDebut.toStartOfDay()).isBefore(now) &&
        (messageImportant.dateFin.toEndOfDay()).isAfter(now) &&
        messageImportant.message.isNotEmpty) {
      return messageImportant.message;
    }
  }
  return null;
}

extension StringImageExt on String {
  bool isImage() => endsWith(".jpg") || endsWith(".jpeg") || endsWith(".png") || endsWith(".webp");
}
