class UserAction {
  final int id;
  final String content;
  final bool isDone;

  UserAction({
    required this.id,
    required this.content,
    required this.isDone,
  });

  factory UserAction.fromJson(dynamic json) {
    return UserAction(
      id: json['id'] as int,
      content: json['content'] as String,
      isDone: json['isDone'] as bool,
    );
  }
}
