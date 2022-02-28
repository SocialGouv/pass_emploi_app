import 'package:pass_emploi_app/models/user_action.dart';

class UserActionCreateRequestAction {
  final String content;
  final String? comment;
  final UserActionStatus initialStatus;

  UserActionCreateRequestAction(this.content, this.comment, this.initialStatus);
}

class UserActionCreateLoadingAction {}

class UserActionCreateSuccessAction {}

class UserActionCreateFailureAction {}

class UserActionCreateResetAction {}
