import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class PutUserActionRequest implements JsonSerializable {
  final UserActionUpdateRequest request;

  PutUserActionRequest(this.request);

  @override
  Map<String, dynamic> toJson() => {
        "status": _statusToString(request.status),
        "contenu": request.contenu,
        if (request.description != null) "description": request.description,
        "dateEcheance": request.dateEcheance.toIso8601WithOffsetDateTime(),
        "codeQualification": request.type.code,
      };

  String _statusToString(UserActionStatus status) {
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
