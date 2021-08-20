import 'package:pass_emploi_app/models/user.dart';

// TODO Use factory
abstract class LoginAction {}

class LoggedInAction extends LoginAction {
  final User user;

  LoggedInAction(this.user);
}

class NotLoggedInAction extends LoginAction {}

class LoginLoadingAction extends LoginAction {
  final String firstName;
  final String lastName;

  LoginLoadingAction(this.firstName, this.lastName);
}

class LoginFailureAction extends LoginAction {
  final String firstName;
  final String lastName;

  LoginFailureAction(this.firstName, this.lastName);
}
