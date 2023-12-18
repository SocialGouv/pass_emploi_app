import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';

class UserActionCreateRequest extends Equatable {
  final String content;
  final String? comment;
  final DateTime dateEcheance;
  final bool rappel;
  final UserActionStatus initialStatus;
  final UserActionReferentielType codeQualification;

  UserActionCreateRequest(
    this.content,
    this.comment,
    this.dateEcheance,
    this.rappel,
    this.initialStatus,
    this.codeQualification,
  );

  @override
  List<Object?> get props => [content, comment, dateEcheance, rappel, initialStatus, codeQualification];

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'comment': comment,
      'dateEcheance': dateEcheance.microsecondsSinceEpoch,
      'rappel': rappel,
      'initialStatus': initialStatus.toString(),
      'codeQualification': codeQualification.toCode
    };
  }

  factory UserActionCreateRequest.fromJson(dynamic json) {
    return UserActionCreateRequest(
      json['content'] as String,
      json['comment'] as String?,
      DateTime.fromMicrosecondsSinceEpoch(json['dateEcheance'] as int),
      json['rappel'] as bool,
      UserActionStatus.fromString(json['initialStatus'] as String),
      UserActionReferentielTypeExt.fromCode(json['codeQualification'] as String?),
    );
  }
}
