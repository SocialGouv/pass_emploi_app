import 'package:pass_emploi_app/models/user_action.dart';

abstract class UserActionAction {}

class UserActionLoadingAction extends UserActionAction {}

class UserActionSuccessAction extends UserActionAction {
  final List<UserAction> actions;

  UserActionSuccessAction(this.actions);
}

class UserActionFailureAction extends UserActionAction {}

class UserActionCreatedWithSuccessAction extends UserActionAction {}

class UserActionCreationFailed extends UserActionAction {}

class UserActionDeleteAction extends UserActionAction {
  final String actionId;

  UserActionDeleteAction(this.actionId);
}

class UserActionDeleteLoadingAction extends UserActionAction {}

class UserActionDeleteSuccessAction extends UserActionAction {
  final String actionId;

  UserActionDeleteSuccessAction(this.actionId);
}

class UserActionDeleteFailureAction extends UserActionAction {}

class UserActionUpdateStatusAction extends UserActionAction {
  final String userId;
  final String actionId;
  final UserActionStatus newStatus;

  UserActionUpdateStatusAction({required this.userId, required this.actionId, required this.newStatus});
}

class RequestUserActionsAction extends UserActionAction {}

class DismissUserActionDetailsAction extends UserActionAction {}

class UserActionNoUpdateNeededAction extends UserActionAction {}

class CreateUserAction extends UserActionAction {
  final String content;
  final String? comment;
  final UserActionStatus initialStatus;

  CreateUserAction(this.content, this.comment, this.initialStatus);
}

class DismissCreateUserAction extends UserActionAction {}
