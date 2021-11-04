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
