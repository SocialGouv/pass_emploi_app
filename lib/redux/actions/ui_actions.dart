abstract class UiAction {}

class BootstrapAction extends UiAction {}

class LogoutAction extends UiAction {}

class UpdateActionStatus extends UiAction {
  final String actionId;
  final bool newIsDoneValue;

  UpdateActionStatus({required this.actionId, required this.newIsDoneValue});
}

class SendMessageAction extends UiAction {
  final String message;

  SendMessageAction(this.message);
}

class RequestLoginAction extends UiAction {
  final String firstName;
  final String lastName;

  RequestLoginAction(this.firstName, this.lastName);
}

class RequestHomeAction extends UiAction {
  final String userId;

  RequestHomeAction(this.userId);
}
