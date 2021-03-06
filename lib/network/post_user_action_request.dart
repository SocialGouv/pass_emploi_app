import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

class PostUserActionRequest implements JsonSerializable {
  final String content;
  final String? comment;
  final UserActionStatus status;

  PostUserActionRequest({required this.content, required this.comment, required this.status});

  @override
  Map<String, dynamic> toJson() => {"content": content, "comment": comment, "status": _toString(status)};

  String _toString(UserActionStatus status) {
    switch (status) {
      case UserActionStatus.NOT_STARTED:
        return "not_started";
      case UserActionStatus.IN_PROGRESS:
        return "in_progress";
      case UserActionStatus.CANCELED:
        return "canceled";
      case UserActionStatus.DONE:
        return "done";
    }
  }
}
