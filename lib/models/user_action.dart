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
  final DateTime dateEcheance;
  final UserActionCreator creator;

  UserAction({
    required this.id,
    required this.content,
    required this.comment,
    required this.status,
    required this.dateEcheance,
    required this.creator,
  });

  factory UserAction.fromJson(dynamic json) {
    return UserAction(
      id: json['id'] as String,
      content: json['content'] as String,
      comment: json['comment'] as String,
      status: _statusFromString(statusString: json['status'] as String),
      dateEcheance: (json['dateEcheance'] as String).toDateTimeUtcOnLocalTimeZone(),
      creator: _creator(json),
    );
  }

  UserAction copyWith({
    final String? id,
    final String? content,
    final String? comment,
    final UserActionStatus? status,
    final DateTime? dateEcheance,
    final UserActionCreator? creator,
  }) {
    return UserAction(
      id: id ?? this.id,
      content: content ?? this.content,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      dateEcheance: dateEcheance ?? this.dateEcheance,
      creator: creator ?? this.creator,
    );
  }

  bool isLate() => !(dateEcheance.isToday() || dateEcheance.isAfter(clock.now()));

  @override
  List<Object?> get props => [id, comment, content, status, dateEcheance, creator];
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

extension UpdateActionList on List<UserAction> {
  List<UserAction> withUpdatedAction(String actionId, UserActionStatus status) {
    final actionToUpdate = firstWhere((a) => a.id == actionId);
    final updatedAction = actionToUpdate.copyWith(status: status);
    return List<UserAction>.from(this) //
        .where((a) => a.id != actionId)
        .toList()
      ..insert(0, updatedAction);
  }

  bool shouldUpdateActionStatus(String id, UserActionStatus status) {
    final userAction = firstWhere((e) => e.id == id);
    return userAction.status != status;
  }
}
