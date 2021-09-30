import 'package:pass_emploi_app/utils/string_extensions.dart';

class UserAction {
  final String id;
  final String content;
  final String comment;
  final bool isDone;
  final DateTime lastUpdate;

  UserAction({
    required this.id,
    required this.content,
    required this.comment,
    required this.isDone,
    required this.lastUpdate,
  });

  factory UserAction.fromJson(dynamic json) {
    return UserAction(
      id: json['id'] as String,
      content: json['content'] as String,
      comment: json['comment'] as String,
      isDone: json['isDone'] as bool,
      lastUpdate: (json['lastUpdate'] as String).toDateTime(),
    );
  }
}
