import 'package:pass_emploi_app/models/user_action.dart';

import 'json_serializable.dart';

class PatchUserActionRequest implements JsonSerializable {
  final UserActionStatus status;

  PatchUserActionRequest({required this.status});

  @override
  Map<String, dynamic> toJson() => {"status": _toString(status)};

  _toString(UserActionStatus status) {
    switch (status) {
      case UserActionStatus.NOT_STARTED:
        return "not_started";
      case UserActionStatus.IN_PROGRESS:
        return "in_progress";
      case UserActionStatus.DONE:
        return "done";
    }
  }
}
