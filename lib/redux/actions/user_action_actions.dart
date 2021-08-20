import 'package:pass_emploi_app/models/home.dart';

abstract class UserActionAction {}

class UserActionLoadingAction extends UserActionAction {}

class UserActionSuccessAction extends UserActionAction {
  final Home home;

  UserActionSuccessAction(this.home);
}

class UserActionFailureAction extends UserActionAction {}
