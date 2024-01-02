import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class PostUserActionRequest implements JsonSerializable {
  final UserActionCreateRequest request;

  PostUserActionRequest(this.request);

  @override
  Map<String, dynamic> toJson() => {
        "content": request.content,
        if (request.comment != null) "comment": request.comment,
        "status": _toString(request.initialStatus),
        "dateEcheance": request.dateEcheance.toIso8601WithOffsetDateTime(),
        "rappel": request.rappel,
        "codeQualification": request.codeQualification.code,
      };

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
