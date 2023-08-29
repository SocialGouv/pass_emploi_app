import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/message.dart';

sealed class ChatItem extends Equatable {
  final String messageId;

  ChatItem(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class DayItem extends ChatItem {
  final String dayLabel;

  DayItem(this.dayLabel) : super("");

  @override
  List<Object?> get props => [messageId, dayLabel];
}

class InformationItem extends ChatItem {
  final String title;
  final String description;

  InformationItem(this.title, this.description) : super("");

  @override
  List<Object?> get props => [messageId, title, description];
}

sealed class MessageItem extends ChatItem {
  final String content;
  final String caption;

  MessageItem(String messageId, this.content, this.caption) : super(messageId);

  @override
  List<Object?> get props => [messageId, content, caption];
}

class TextMessageItem extends MessageItem {
  final Sender sender;

  TextMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required this.sender,
  }) : super(messageId, content, caption);

  @override
  List<Object?> get props => [messageId, content, caption, sender];
}

abstract class PartageMessageItem extends MessageItem {
  final String idPartage;
  final String titrePartage;
  final Sender sender;

  PartageMessageItem(super.messageId, super.content, super.caption, this.idPartage, this.titrePartage, this.sender);

  @override
  List<Object?> get props => [messageId, content, caption, idPartage, titrePartage, sender];
}

class OffreMessageItem extends PartageMessageItem {
  final OffreType type;

  OffreMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required Sender sender,
    required String idPartage,
    required String titrePartage,
    required this.type,
  }) : super(messageId, content, caption, idPartage, titrePartage, sender);

  @override
  List<Object?> get props => [messageId, content, caption, sender, idPartage, titrePartage, type];
}

class EventMessageItem extends PartageMessageItem {
  EventMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required Sender sender,
    required String idPartage,
    required String titrePartage,
  }) : super(messageId, content, caption, idPartage, titrePartage, sender);

  @override
  List<Object?> get props => [messageId, content, caption, sender, idPartage, titrePartage];
}

class EvenementEmploiMessageItem extends PartageMessageItem {
  EvenementEmploiMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required Sender sender,
    required String idPartage,
    required String titrePartage,
  }) : super(messageId, content, caption, idPartage, titrePartage, sender);

  @override
  List<Object?> get props => [messageId, content, caption, sender, idPartage, titrePartage];
}

class SessionMiloMessageItem extends PartageMessageItem {
  SessionMiloMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required Sender sender,
    required String idPartage,
    required String titrePartage,
  }) : super(messageId, content, caption, idPartage, titrePartage, sender);

  @override
  List<Object?> get props => [messageId, content, caption, sender, idPartage, titrePartage];
}

class PieceJointeConseillerMessageItem extends ChatItem {
  final String pieceJointeId;
  final String message;
  final String filename;
  final String caption;

  PieceJointeConseillerMessageItem({
    required String messageId,
    required this.pieceJointeId,
    required this.message,
    required this.filename,
    required this.caption,
  }) : super(messageId);

  @override
  List<Object?> get props => [messageId, pieceJointeId, message, filename, caption];
}
