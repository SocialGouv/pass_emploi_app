import 'package:pass_emploi_app/models/user_action_PE.dart';

class UserActionPEListRequestAction {}

class UserActionPEListLoadingAction {}

class UserActionPEListSuccessAction {
  final List<UserActionPE> userActions;

  UserActionPEListSuccessAction(this.userActions);
}

class UserActionPEListFailureAction {}

class UserActionPEListResetAction {}
