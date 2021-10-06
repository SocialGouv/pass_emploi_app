import 'json_serializable.dart';

class PatchUserActionRequest implements JsonSerializable{
  final bool isDone;

  PatchUserActionRequest({required this.isDone});

  @override
  Map<String, dynamic> toJson() => {'isDone': isDone};
}
