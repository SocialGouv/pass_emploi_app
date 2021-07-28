import 'package:pass_emploi_app/models/user.dart';

abstract class LoginState {
  LoginState._();

  factory LoginState.loginCompleted(User user) = LoginCompleted;

  factory LoginState.notInitialized() = LoginNotInitialized;
}

class LoginCompleted extends LoginState {
  final User user;

  LoginCompleted(this.user) : super._();
}

class LoginNotInitialized extends LoginState {
  LoginNotInitialized() : super._();
}
