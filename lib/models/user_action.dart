import 'package:pass_emploi_app/utils/string_extensions.dart';

class UserAction {
  final String id;
  final String content;
  final bool isDone;
  final DateTime lastUpdate;

  UserAction({
    required this.id,
    required this.content,
    required this.isDone,
    required this.lastUpdate,
  });

  factory UserAction.fromJson(dynamic json) {
    return UserAction(
      id: json['id'] as String,
      content: json['content'] as String,
      isDone: json['isDone'] as bool,
      lastUpdate: (json['lastUpdate'] as String).toDateTime(),
    );
  }
}
