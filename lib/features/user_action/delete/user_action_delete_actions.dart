class UserActionDeleteRequestAction {
  final String actionId;

  UserActionDeleteRequestAction(this.actionId);
}

class UserActionDeleteLoadingAction {}

class UserActionDeleteSuccessAction {}

class UserActionDeleteFromListAction {
  final String actionId;

  UserActionDeleteFromListAction(this.actionId);
}

class UserActionDeleteFailureAction {}

class UserActionDeleteResetAction {}
