import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';

sealed class CvmMessage extends Equatable {
  final String id;
  final DateTime date;
  final bool readByJeune;

  CvmMessage({required this.id, required this.date, required this.readByJeune});

  bool isFromConseiller() {
    return switch (this) {
      final CvmTextMessage message => message.sentBy == Sender.conseiller,
      final CvmFileMessage message => message.sentBy == Sender.conseiller,
      CvmUnknownMessage() => true,
    };
  }
}

class CvmTextMessage extends CvmMessage {
  final Sender sentBy;
  final String content;
  final bool readByConseiller;

  CvmTextMessage({
    required super.id,
    required super.date,
    required super.readByJeune,
    required this.sentBy,
    required this.content,
    required this.readByConseiller,
  });

  @override
  List<Object?> get props => [id, date, readByJeune, sentBy, content, readByConseiller];
}

class CvmFileMessage extends CvmMessage {
  final Sender sentBy;
  final String url;
  final String fileName;
  final String fileId;

  CvmFileMessage({
    required super.id,
    required super.date,
    required super.readByJeune,
    required this.sentBy,
    required this.url,
    required this.fileName,
    required this.fileId,
  });

  @override
  List<Object?> get props => [id, date, readByJeune, sentBy, fileName, url, fileId];
}

class CvmUnknownMessage extends CvmMessage {
  CvmUnknownMessage({required super.id, required super.date, required super.readByJeune});

  @override
  List<Object?> get props => [id, date, readByJeune];
}
