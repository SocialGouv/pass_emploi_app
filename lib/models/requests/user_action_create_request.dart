import 'package:pass_emploi_app/models/user_action.dart';

class UserActionCreateRequest {
  final String content;
  final String? comment;
  final DateTime dateEcheance;
  final bool rappel;
  final UserActionStatus initialStatus;

  UserActionCreateRequest(this.content, this.comment, this.dateEcheance, this.rappel, this.initialStatus);
}
