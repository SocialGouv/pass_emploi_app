import 'package:pass_emploi_app/models/user_action.dart';

class UserActionDetailsRequestAction {
  final String userActionId;

  UserActionDetailsRequestAction(this.userActionId);
}

class UserActionDetailsLoadingAction {}

class UserActionDetailsSuccessAction {
  final UserAction result;

  UserActionDetailsSuccessAction(this.result);
}

class UserActionDetailsFailureAction {}

class UserActionDetailsResetAction {}
