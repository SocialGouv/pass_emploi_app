import 'package:pass_emploi_app/models/user.dart';

abstract class LoginState {
  LoginState._();

  factory LoginState.loggedIn(User user) = LoggedInState;

  factory LoginState.notLoggedIn() = NotLoggedInState;

  factory LoginState.loading(String firstName, String lastName) = LoginLoadingState;

  factory LoginState.failure(String firstName, String lastName) = LoginFailureState;

  factory LoginState.notInitialized() = LoginNotInitializedState;
}

class LoggedInState extends LoginState {
  final User user;

  LoggedInState(this.user) : super._();
}

class NotLoggedInState extends LoginState {
  NotLoggedInState() : super._();
}

class LoginLoadingState extends LoginState {
  final String firstName;
  final String lastName;

  LoginLoadingState(this.firstName, this.lastName) : super._();
}

class LoginFailureState extends LoginState {
  final String firstName;
  final String lastName;

  LoginFailureState(this.firstName, this.lastName) : super._();
}

class LoginNotInitializedState extends LoginState {
  LoginNotInitializedState() : super._();
}
