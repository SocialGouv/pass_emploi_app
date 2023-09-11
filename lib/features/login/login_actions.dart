import 'package:pass_emploi_app/models/user.dart';

enum RequestLoginMode { PASS_EMPLOI, SIMILO, POLE_EMPLOI, DEMO_PE, DEMO_MILO }

extension RequestLoginModeModeExtension on RequestLoginMode {
  bool isDemo() => this == RequestLoginMode.DEMO_PE || this == RequestLoginMode.DEMO_MILO;
}

class LoginRequestAction {}

class LoginLoadingAction {}

class TryConnectChatAgainAction {}

class LoginSuccessAction {
  final User user;

  LoginSuccessAction(this.user);
}

class LoginFailureAction {}

class NotLoggedInAction {}

class RequestLoginAction {
  final RequestLoginMode mode;

  RequestLoginAction(this.mode);
}

class RequestLogoutAction {}
