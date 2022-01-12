import 'package:pass_emploi_app/redux/actions/named_actions.dart';

enum RequestLoginMode { PASS_EMPLOI, SIMILO, POLE_EMPLOI }
enum LogoutRequester { SYSTEM, USER }

class NotLoggedInAction extends LoginAction {}

class RequestLoginAction extends LoginAction {
  final RequestLoginMode mode;

  RequestLoginAction(this.mode);
}

class RequestLogoutAction extends LoginAction {
  final LogoutRequester logoutRequester;

  RequestLogoutAction(this.logoutRequester);
}
