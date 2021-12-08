
abstract class UiAction {}

class BootstrapAction extends UiAction {}

class SendMessageAction extends UiAction {
  final String message;

  SendMessageAction(this.message);
}

class LastMessageSeenAction extends UiAction {}
