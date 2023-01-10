import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/message.dart';

abstract class ChatItem extends Equatable {}

class DayItem extends ChatItem {
  final String dayLabel;

  DayItem(this.dayLabel);

  @override
  List<Object?> get props => [dayLabel];
}

class InformationItem extends ChatItem {
  final String title;
  final String description;

  InformationItem(this.title, this.description);

  @override
  List<Object?> get props => [title, description];
}

abstract class MessageItem extends ChatItem {
  final String content;
  final String caption;

  MessageItem(this.content, this.caption);

  @override
  List<Object?> get props => [content, caption];
}

class TextMessageItem extends MessageItem {
  final Sender sender;

  TextMessageItem({
    required String content,
    required String caption,
    required this.sender,
  }) : super(content, caption);

  @override
  List<Object?> get props => [content, caption, sender];
}

abstract class PartageMessageItem extends MessageItem {
  final String idPartage;
  final String titrePartage;
  final Sender sender;

  PartageMessageItem(super.content, super.caption, this.idPartage, this.titrePartage, this.sender);

  @override
  List<Object?> get props => [content, caption, idPartage, titrePartage, sender];
}

class OffreMessageItem extends PartageMessageItem {
  final OffreType type;

  OffreMessageItem({
    required String content,
    required String caption,
    required Sender sender,
    required String idPartage,
    required String titrePartage,
    required this.type,
  }) : super(content, caption, idPartage, titrePartage, sender);

  @override
  List<Object?> get props => [content, caption, sender, idPartage, titrePartage, type];
}

class EventMessageItem extends PartageMessageItem {
  EventMessageItem({
    required String content,
    required String caption,
    required Sender sender,
    required String idPartage,
    required String titrePartage,
  }) : super(content, caption, idPartage, titrePartage, sender);

  @override
  List<Object?> get props => [content, caption, sender, idPartage, titrePartage];
}

class PieceJointeConseillerMessageItem extends ChatItem {
  final String id;
  final String message;
  final String filename;
  final String caption;

  PieceJointeConseillerMessageItem({
    required this.id,
    required this.message,
    required this.filename,
    required this.caption,
  });

  @override
  List<Object?> get props => [id, message, filename, caption];
}
