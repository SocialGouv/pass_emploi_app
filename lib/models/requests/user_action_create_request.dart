import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/user_action.dart';

class UserActionCreateRequest extends Equatable {
  final String content;
  final String? comment;
  final DateTime dateEcheance;
  final bool rappel;
  final UserActionStatus initialStatus;

  UserActionCreateRequest(
    this.content,
    this.comment,
    this.dateEcheance,
    this.rappel,
    this.initialStatus,
  );

  @override
  List<Object?> get props => [content, comment, dateEcheance, rappel, initialStatus];

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'comment': comment,
      'dateEcheance': dateEcheance.microsecondsSinceEpoch,
      'rappel': rappel,
      'initialStatus': initialStatus.toString(),
    };
  }

  factory UserActionCreateRequest.fromJson(dynamic json) {
    return UserActionCreateRequest(
      json['content'] as String,
      json['comment'] as String?,
      DateTime.fromMicrosecondsSinceEpoch(json['dateEcheance'] as int),
      json['rappel'] as bool,
      UserActionStatus.fromString(json['initialStatus'] as String),
    );
  }
}
