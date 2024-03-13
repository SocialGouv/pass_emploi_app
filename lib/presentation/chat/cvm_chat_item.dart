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

class CvmTextMessageItem extends CvmChatItem {
  final String content;
  final String caption;
  final Sender sender;

  CvmTextMessageItem({
    required String messageId,
    required this.content,
    required this.caption,
    required this.sender,
  }) : super(messageId);

  @override
  List<Object?> get props => [messageId, content, caption, sender];
}

class CvmPieceJointeConseillerMessageItem extends CvmChatItem {
  final String url;
  final String fileId;
  final String fileName;
  final String caption;

  CvmPieceJointeConseillerMessageItem({
    required String messageId,
    required this.url,
    required this.fileName,
    required this.fileId,
    required this.caption,
  }) : super(messageId);

  @override
  List<Object?> get props => [messageId, url, fileId, fileName, caption];
}
