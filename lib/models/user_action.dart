import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

enum UserActionStatus { NOT_STARTED, IN_PROGRESS, DONE }

class UserAction {
  final String id;
  final String content;
  final String comment;
  final UserActionStatus status;
  final DateTime lastUpdate;
  final UserActionCreator creator;

  UserAction({
    required this.id,
    required this.content,
    required this.comment,
    required this.status,
    required this.lastUpdate,
    required this.creator,
  });

  factory UserAction.fromJson(dynamic json) {
    return UserAction(
      id: json['id'] as String,
      content: json['content'] as String,
      comment: json['comment'] as String,
      status: _statusFromString(statusString: json['status'] as String),
      lastUpdate: (json['lastUpdate'] as String).toDateTimeOnLocalTimeZone(),
      creator: _creator(json),
    );
  }
}

UserActionStatus _statusFromString({required String statusString}) {
  if (statusString == "not_started") {
    return UserActionStatus.NOT_STARTED;
  } else if (statusString == "in_progress") {
    return UserActionStatus.IN_PROGRESS;
  } else {
    return UserActionStatus.DONE;
  }
}

UserActionCreator _creator(dynamic json) {
  final creatorType = json["creatorType"] as String;
  if (creatorType == "jeune") {
    return JeuneActionCreator();
  } else {
    var creatorName = json["creator"] as String;
    return ConseillerActionCreator(
      name: creatorName,
    );
  }
}
