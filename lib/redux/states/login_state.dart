import 'package:pass_emploi_app/models/user.dart';

abstract class LoginState {
  LoginState._();

  factory LoginState.loggedIn(User user) = LoggedInState;

  factory LoginState.notLoggedIn() = NotLoggedInState;

  factory LoginState.notInitialized() = LoginNotInitializedState;
}

class LoggedInState extends LoginState {
  final User user;

  LoggedInState(this.user) : super._();
}

class NotLoggedInState extends LoginState {
  NotLoggedInState() : super._();
}

class LoginNotInitializedState extends LoginState {
  LoginNotInitializedState() : super._();
}
