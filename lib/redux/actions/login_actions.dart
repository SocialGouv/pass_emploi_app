import 'package:pass_emploi_app/models/user.dart';

abstract class LoginAction {}

class LoggedInAction extends LoginAction {
  final User user;

  LoggedInAction(this.user);
}

class NotLoggedInAction extends LoginAction {}

class LoginLoadingAction extends LoginAction {}

class LoginFailureAction extends LoginAction {}

class RequestLoginAction extends LoginAction {}

class RequestLogoutAction extends LoginAction {}
