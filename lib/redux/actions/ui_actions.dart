abstract class UiAction {}

class BootstrapAction extends UiAction {}

class UpdateActionStatus extends UiAction {
  final int actionId;
  final bool newIsDoneValue;

  UpdateActionStatus({required this.actionId, required this.newIsDoneValue});
}

class SendMessageAction extends UiAction {
  final String message;

  SendMessageAction(this.message);
}
