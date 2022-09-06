class UserActionDeleteRequestAction {
  final String actionId;

  UserActionDeleteRequestAction(this.actionId);
}

class UserActionDeleteLoadingAction {}

class UserActionDeleteSuccessAction {
  final String actionId;

  UserActionDeleteSuccessAction(this.actionId);
}

class UserActionDeleteFailureAction {}

class UserActionDeleteResetAction {}
