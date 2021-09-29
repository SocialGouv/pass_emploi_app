abstract class UiAction {}

class BootstrapAction extends UiAction {}

class LogoutAction extends UiAction {}

class UpdateActionStatus extends UiAction {
  final String userId;
  final String actionId;
  final bool newIsDoneValue;

  UpdateActionStatus({required this.userId, required this.actionId, required this.newIsDoneValue});
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
