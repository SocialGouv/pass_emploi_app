import 'package:pass_emploi_app/models/user_action.dart';

abstract class UiAction {}

class BootstrapAction extends UiAction {}

class SendMessageAction extends UiAction {
  final String message;

  SendMessageAction(this.message);
}

class LastMessageSeenAction extends UiAction {}

class RequestUserActionsAction extends UiAction {
  final String userId;

  RequestUserActionsAction(this.userId);
}

class RequestRendezvousAction extends UiAction {}

class DismissUserActionDetailsAction extends UiAction {}

class UserActionNoUpdateNeededAction extends UiAction {}

class CreateUserAction extends UiAction {
  final String content;
  final String? comment;
  final UserActionStatus initialStatus;

  CreateUserAction(this.content, this.comment, this.initialStatus);
}

class DismissCreateUserAction extends UiAction {}
