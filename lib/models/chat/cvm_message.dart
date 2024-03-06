import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';

sealed class CvmMessage extends Equatable {
  final String id;
  final DateTime date;

  CvmMessage({required this.id, required this.date});
}

class CvmTextMessage extends CvmMessage {
  final Sender sentBy;
  final String content;

  CvmTextMessage({
    required super.id,
    required super.date,
    required this.sentBy,
    required this.content,
  });

  @override
  List<Object?> get props => [id, date, sentBy, content];
}

class CvmFileMessage extends CvmMessage {
  final Sender sentBy;
  final String url;
  final String fileName;
  final String fileId;

  CvmFileMessage({
    required super.id,
    required super.date,
    required this.sentBy,
    required this.url,
    required this.fileName,
    required this.fileId,
  });

  @override
  List<Object?> get props => [id, date, sentBy, fileName, url, fileId];
}

class CvmUnknownMessage extends CvmMessage {
  CvmUnknownMessage({required super.id, required super.date});

  @override
  List<Object?> get props => [id, date];
}
