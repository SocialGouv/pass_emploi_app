import 'package:pass_emploi_app/models/user.dart';

enum RequestLoginMode { GENERIC, SIMILO }

abstract class LoginAction {}

class LoggedInAction extends LoginAction {
  final User user;

  LoggedInAction(this.user);
}

class NotLoggedInAction extends LoginAction {}

class LoginLoadingAction extends LoginAction {}

class LoginFailureAction extends LoginAction {}

class RequestLoginAction extends LoginAction {
  final RequestLoginMode mode;

  RequestLoginAction(this.mode);
}

class RequestLogoutAction extends LoginAction {}
