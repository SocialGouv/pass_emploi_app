import 'package:pass_emploi_app/models/user_action.dart';

class UserActionListRequestAction {
  final bool forceRefresh;

  UserActionListRequestAction({this.forceRefresh = false});
}

class UserActionListLoadingAction {}

class UserActionListSuccessAction {
  final List<UserAction> userActions;

  UserActionListSuccessAction(this.userActions);
}

class UserActionListFailureAction {}

class UserActionListResetAction {}
