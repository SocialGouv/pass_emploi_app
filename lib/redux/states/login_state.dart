import 'package:pass_emploi_app/models/user.dart';

abstract class LoginState {
  LoginState._();

  factory LoginState.loggedIn(User user) = LoggedInState;

  factory LoginState.notLoggedIn() = NotLoggedInState;

  factory LoginState.loading(String accessCode) = LoginLoadingState;

  factory LoginState.failure(String accessCode) = LoginFailureState;

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
  final String accessCode;

  LoginLoadingState(this.accessCode) : super._();
}

class LoginFailureState extends LoginState {
  final String accessCode;

  LoginFailureState(this.accessCode) : super._();
}

class LoginNotInitializedState extends LoginState {
  LoginNotInitializedState() : super._();
}
