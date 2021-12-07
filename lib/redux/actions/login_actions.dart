import 'package:pass_emploi_app/models/user.dart';

abstract class LoginAction {}

class LoggedInAction extends LoginAction {
  final User user;

  LoggedInAction(this.user);
}

class NotLoggedInAction extends LoginAction {}

class RequestLoginActionV2 extends LoginAction {}

// TOD0-115 remove accesscode
class LoginLoadingAction extends LoginAction {
  final String accessCode;

  LoginLoadingAction(this.accessCode);
}

// TOD0-115 remove accesscode
class LoginFailureAction extends LoginAction {
  final String accessCode;

  LoginFailureAction(this.accessCode);
}

class LogoutAction extends LoginAction {}
