import 'package:pass_emploi_app/utils/string_extensions.dart';

enum UserActionStatus { NOT_STARTED, IN_PROGRESS, DONE }

class UserAction {
  final String id;
  final String content;
  final String comment;
  final UserActionStatus status;
  final DateTime lastUpdate;

  UserAction({
    required this.id,
    required this.content,
    required this.comment,
    required this.status,
    required this.lastUpdate,
  });

  factory UserAction.fromJson(dynamic json) {
    return UserAction(
      id: json['id'] as String,
      content: json['content'] as String,
      comment: json['comment'] as String,
      status: json['isDone'] as bool ? UserActionStatus.DONE : UserActionStatus.NOT_STARTED,
      lastUpdate: (json['lastUpdate'] as String).toDateTime(),
    );
  }
}
