import 'package:pass_emploi_app/models/user.dart';

abstract class LoginAction {}

class LoggedInAction extends LoginAction {
  final User user;

  LoggedInAction(this.user);
}

class NotLoggedInAction extends LoginAction {}

class LoginLoadingAction extends LoginAction {
  final String accessCode;

  LoginLoadingAction(this.accessCode);
}

class LoginFailureAction extends LoginAction {
  final String accessCode;

  LoginFailureAction(this.accessCode);
}
