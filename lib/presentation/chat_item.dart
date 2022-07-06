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

class JeuneMessageItem extends MessageItem {
  JeuneMessageItem({required String content, required String caption}) : super(content, caption);
}

class ConseillerMessageItem extends MessageItem {
  ConseillerMessageItem({required String content, required String caption}) : super(content, caption);
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

class OffreMessageItem extends ChatItem {
  final String content;
  final String idOffre;
  final String titreOffre;
  final String caption;
  final OffreType type;

  OffreMessageItem({
    required this.content,
    required this.idOffre,
    required this.titreOffre,
    required this.caption,
    required this.type,
  });

  @override
  List<Object?> get props => [content, idOffre, titreOffre, caption, type];
}
