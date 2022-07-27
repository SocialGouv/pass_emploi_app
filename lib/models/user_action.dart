import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

enum UserActionStatus { NOT_STARTED, IN_PROGRESS, CANCELED, DONE }

extension UserActionStatusExtension on UserActionStatus {
  bool isCanceledOrDone() {
    return this == UserActionStatus.CANCELED || this == UserActionStatus.DONE;
  }
}

class UserAction extends Equatable {
  final String id;
  final String content;
  final String comment;
  final UserActionStatus status;
  final DateTime lastUpdate;
  final DateTime dateEcheance;
  final UserActionCreator creator;

  UserAction({
    required this.id,
    required this.content,
    required this.comment,
    required this.status,
    required this.lastUpdate,
    required this.dateEcheance,
    required this.creator,
  });

  factory UserAction.fromJson(dynamic json) {
    return UserAction(
      id: json['id'] as String,
      content: json['content'] as String,
      comment: json['comment'] as String,
      status: _statusFromString(statusString: json['status'] as String),
      lastUpdate: (json['lastUpdate'] as String).toDateTimeOnLocalTimeZone(),
      dateEcheance: (json['dateEcheance'] as String).toDateTimeOnLocalTimeZone(),
      creator: _creator(json),
    );
  }

  bool isLate() => !(dateEcheance.isToday() || dateEcheance.isAfter(clock.now()));

  @override
  List<Object?> get props => [id, comment, content, status, lastUpdate, dateEcheance, creator];
}

UserActionStatus _statusFromString({required String statusString}) {
  if (statusString == "not_started") {
    return UserActionStatus.NOT_STARTED;
  } else if (statusString == "in_progress") {
    return UserActionStatus.IN_PROGRESS;
  } else if (statusString == "canceled") {
    return UserActionStatus.CANCELED;
  } else {
    return UserActionStatus.DONE;
  }
}

UserActionCreator _creator(dynamic json) {
  final creatorType = json["creatorType"] as String;
  if (creatorType == "jeune") {
    return JeuneActionCreator();
  } else {
    final creatorName = json["creator"] as String;
    return ConseillerActionCreator(
      name: creatorName,
    );
  }
}
