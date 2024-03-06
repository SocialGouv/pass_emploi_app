import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';

sealed class CvmChatItem extends Equatable {
  final String messageId;

  CvmChatItem(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class CvmDayItem extends CvmChatItem {
  final String dayLabel;

  CvmDayItem(this.dayLabel) : super('');

  @override
  List<Object?> get props => [messageId, dayLabel];
}

class CvmInformationItem extends CvmChatItem {
  final String title;
  final String description;

  CvmInformationItem(this.title, this.description) : super('');

  @override
  List<Object?> get props => [messageId, title, description];
}

sealed class CvmMessageItem extends CvmChatItem {
  final String content;
  final String caption;

  CvmMessageItem(super.messageId, this.content, this.caption);

  @override
  List<Object?> get props => [
        messageId,
        content,
        caption,
      ];
}

class CvmTextMessageItem extends CvmMessageItem {
  final Sender sender;

  CvmTextMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required this.sender,
  }) : super(messageId, content, caption);

  @override
  List<Object?> get props => [messageId, content, caption, sender];
}

class CvmPieceJointeConseillerMessageItem extends CvmMessageItem {
  final String attachmentUrl;
  final String fileId;

  CvmPieceJointeConseillerMessageItem({
    required String messageId,
    required String content,
    required String caption,
    required this.attachmentUrl,
    required this.fileId,
  }) : super(messageId, content, caption);

  @override
  List<Object?> get props => [messageId, content, caption, attachmentUrl, fileId];
}
