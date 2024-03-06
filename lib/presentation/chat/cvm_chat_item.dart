import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';

sealed class CvmChatItem extends Equatable {
  final String messageId;

  CvmChatItem(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class DayItem extends CvmChatItem {
  final String dayLabel;

  DayItem(this.dayLabel) : super('');

  @override
  List<Object?> get props => [messageId, dayLabel];
}

class InformationItem extends CvmChatItem {
  final String title;
  final String description;

  InformationItem(this.title, this.description) : super('');

  @override
  List<Object?> get props => [messageId, title, description];
}

sealed class MessageItem extends CvmChatItem {
  final String content;
  final String caption;

  MessageItem(super.messageId, this.content, this.caption);

  @override
  List<Object?> get props => [
        messageId,
        content,
        caption,
      ];
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

class PieceJointeConseillerMessageItem extends MessageItem {
  final String attachmentUrl;
  final String fileId;

  PieceJointeConseillerMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required this.attachmentUrl,
    required this.fileId,
  }) : super(messageId, content, caption);

  @override
  List<Object?> get props => [messageId, content, caption, attachmentUrl, fileId];
}
