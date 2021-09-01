import 'package:pass_emploi_app/models/user_action.dart';

// TODO Use factory
abstract class UserActionAction {}

class UserActionLoadingAction extends UserActionAction {}

class UserActionSuccessAction extends UserActionAction {
  final List<UserAction> actions;

  UserActionSuccessAction(this.actions);
}

class UserActionFailureAction extends UserActionAction {}
