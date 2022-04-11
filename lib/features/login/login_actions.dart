import 'package:pass_emploi_app/models/user.dart';

enum RequestLoginMode { PASS_EMPLOI, SIMILO, POLE_EMPLOI }

class LoginRequestAction {}

class LoginLoadingAction {}

class LoginSuccessAction {
  final User user;

  LoginSuccessAction(this.user);
}

class LoginFailureAction {}

class LoginResetAction {}

class NotLoggedInAction {}

class RequestLoginAction {
  final RequestLoginMode mode;

  RequestLoginAction(this.mode);
}

class RequestLogoutAction {}
