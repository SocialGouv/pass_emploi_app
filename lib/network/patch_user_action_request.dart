class PatchUserActionRequest {
  final bool isDone;

  PatchUserActionRequest({required this.isDone});

  Map<String, dynamic> toJson() => {'isDone': isDone};
}
