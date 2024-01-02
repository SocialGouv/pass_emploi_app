import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

enum UserActionStatus {
  NOT_STARTED,
  IN_PROGRESS,
  CANCELED,
  DONE;

  static UserActionStatus fromString(String statusString) {
    return switch (statusString) {
      'IN_PROGRESS' => UserActionStatus.IN_PROGRESS,
      'CANCELED' => UserActionStatus.CANCELED,
      'DONE' => UserActionStatus.DONE,
      _ => UserActionStatus.NOT_STARTED,
    };
  }
}

enum UserActionQualificationStatus {
  A_QUALIFIER,
  NON_QUALIFIABLE,
  QUALIFIEE;

  static UserActionQualificationStatus? fromString(String? qualificationString) {
    return switch (qualificationString) {
      'NON_QUALIFIABLE' => UserActionQualificationStatus.NON_QUALIFIABLE,
      'QUALIFIEE' => UserActionQualificationStatus.QUALIFIEE,
      'A_QUALIFIER' => UserActionQualificationStatus.A_QUALIFIER,
      _ => null,
    };
  }
}

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
  final DateTime creationDate;
  final UserActionCreator creator;
  final UserActionReferentielType? type;
  final UserActionQualificationStatus? qualificationStatus;

  UserAction({
    required this.id,
    required this.content,
    required this.comment,
    required this.status,
    required this.dateEcheance,
    required this.creationDate,
    required this.creator,
    this.qualificationStatus,
    this.type,
  });

  factory UserAction.fromJson(dynamic json) {
    return UserAction(
      id: json['id'] as String,
      content: json['content'] as String,
      comment: json['comment'] as String,
      status: _statusFromString(statusString: json['status'] as String),
      dateEcheance: (json['dateEcheance'] as String).toDateTimeUtcOnLocalTimeZone(),
      creationDate: (json['creationDate'] as String).toDateTimeOnLocalTimeZone(),
      creator: _creator(json),
      qualificationStatus: UserActionQualificationStatus.fromString(json['qualificationStatus'] as String?),
      type: json['qualification'] != null
          ? UserActionReferentielType.fromCode(json['qualification']["code"] as String)
          : null,
    );
  }

  UserAction copyWith({
    final String? id,
    final String? content,
    final String? comment,
    final UserActionStatus? status,
    final DateTime? dateEcheance,
    final DateTime? creationDate,
    final UserActionCreator? creator,
    final UserActionQualificationStatus? qualificationStatus,
    final UserActionReferentielType? type,
  }) {
    return UserAction(
      id: id ?? this.id,
      content: content ?? this.content,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      dateEcheance: dateEcheance ?? this.dateEcheance,
      creationDate: creationDate ?? this.creationDate,
      creator: creator ?? this.creator,
      qualificationStatus: qualificationStatus ?? this.qualificationStatus,
      type: type ?? this.type,
    );
  }

  bool isLate() => !(dateEcheance.isToday() || dateEcheance.isAfter(clock.now()));

  @override
  List<Object?> get props => [id, comment, content, status, dateEcheance, creator, qualificationStatus, type];
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
  List<UserAction> withUpdatedAction(String actionId, UserActionUpdateRequest request) {
    final actionToUpdate = firstWhereOrNull((a) => a.id == actionId);
    if (actionToUpdate == null) return this;

    final updatedAction = actionToUpdate.copyWith(
      status: request.status,
      content: request.contenu,
      comment: request.description,
      dateEcheance: request.dateEcheance,
      type: request.type,
    );
    return List<UserAction>.from(this) //
        .where((a) => a.id != actionId)
        .toList()
      ..insert(0, updatedAction);
  }

  bool shouldUpdateActionStatus(String id, UserActionStatus status) {
    final userAction = firstWhereOrNull((e) => e.id == id);
    if (userAction == null) return false;
    return userAction.status != status;
  }
}
