import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/models/user.dart';

// TODO: remove
enum RequestLoginMode {
  PASS_EMPLOI,
  SIMILO,
  POLE_EMPLOI,
  DEMO_PE,
  DEMO_MILO;

  LoginMode get toLoginMode => switch (this) {
        RequestLoginMode.PASS_EMPLOI => LoginMode.PASS_EMPLOI,
        RequestLoginMode.SIMILO => LoginMode.MILO,
        RequestLoginMode.POLE_EMPLOI => LoginMode.POLE_EMPLOI,
        RequestLoginMode.DEMO_PE => LoginMode.DEMO_PE,
        RequestLoginMode.DEMO_MILO => LoginMode.DEMO_MILO,
      };
}

enum LogoutReason { userLogout, apiResponse401, expiredRefreshToken, accountSuppression }

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

class LoginFailureAction {
  final String message;

  LoginFailureAction(this.message);
}

class LoginWrongDeviceClockAction {}

class NotLoggedInAction {}

class RequestLoginAction {
  final RequestLoginMode mode;

  RequestLoginAction(this.mode);
}

class RequestLogoutAction {
  final LogoutReason reason;

  RequestLogoutAction(this.reason);
}
