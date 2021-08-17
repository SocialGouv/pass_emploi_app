import 'package:intl/intl.dart';

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
        lastUpdate: extractDateTime(json['lastUpdate']));
  }
}

DateTime extractDateTime(dynamic json) {
  return DateFormat("EEE, d MMM yyyy HH:mm:ss z").parse(json as String);
}
