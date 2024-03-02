import 'package:equatable/equatable.dart';

sealed class CvmEvent extends Equatable {
  final String id;
  final DateTime date;

  CvmEvent({required this.id, required this.date});
}

class CvmMessageEvent extends CvmEvent {
  final bool isFromUser;
  final String content;

  CvmMessageEvent({
    required super.id,
    required super.date,
    required this.isFromUser,
    required this.content,
  });

  @override
  List<Object?> get props => [id, date, isFromUser, content];
}

class CvmFileEvent extends CvmEvent {
  final bool isFromUser;
  final String content;
  final String url;

  CvmFileEvent({
    required super.id,
    required super.date,
    required this.isFromUser,
    required this.content,
    required this.url,
  });

  @override
  List<Object?> get props => [id, date, isFromUser, content, url];
}

class CvmUnknownEvent extends CvmEvent {
  CvmUnknownEvent({required super.id, required super.date});

  @override
  List<Object?> get props => [id, date];
}
