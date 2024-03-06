import 'package:equatable/equatable.dart';

sealed class CvmMessage extends Equatable {
  final String id;
  final DateTime date;

  CvmMessage({required this.id, required this.date});
}

class CvmTextMessage extends CvmMessage {
  final bool isFromUser;
  final String content;

  CvmTextMessage({
    required super.id,
    required super.date,
    required this.isFromUser,
    required this.content,
  });

  @override
  List<Object?> get props => [id, date, isFromUser, content];
}

class CvmFileMessage extends CvmMessage {
  final bool isFromUser;
  final String content;
  final String url;

  CvmFileMessage({
    required super.id,
    required super.date,
    required this.isFromUser,
    required this.content,
    required this.url,
  });

  @override
  List<Object?> get props => [id, date, isFromUser, content, url];
}

class CvmUnknownMessage extends CvmMessage {
  CvmUnknownMessage({required super.id, required super.date});

  @override
  List<Object?> get props => [id, date];
}
