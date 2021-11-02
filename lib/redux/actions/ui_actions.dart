import 'package:pass_emploi_app/models/user_action.dart';

abstract class UiAction {}

class BootstrapAction extends UiAction {}

class LogoutAction extends UiAction {}

class UpdateActionStatus extends UiAction {
  final String userId;
  final String actionId;
  final UserActionStatus newStatus;

  UpdateActionStatus({required this.userId, required this.actionId, required this.newStatus});
}

class SendMessageAction extends UiAction {
  final String message;

  SendMessageAction(this.message);
}

class LastMessageSeenAction extends UiAction {}

class RequestLoginAction extends UiAction {
  final String accessCode;

  RequestLoginAction(this.accessCode);
}

class RequestHomeAction extends UiAction {
  final String userId;

  RequestHomeAction(this.userId);
}

class RequestUserActionsAction extends UiAction {
  final String userId;

  RequestUserActionsAction(this.userId);
}

class DismissUserActionDetailsAction extends UiAction {}

class UserActionNoUpdateNeededAction extends UiAction {}

class CreateUserAction extends UiAction {
  final String? content;
  final String? comment;
  final UserActionStatus initialStatus;

  CreateUserAction(this.content, this.comment, this.initialStatus);
}

class DismissCreateUserAction extends UiAction {}