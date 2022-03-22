import 'package:pass_emploi_app/models/user.dart';

abstract class LoginState {}

class LoginNotInitializedState extends LoginState {}

class UserNotLoggedInState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final User user;

  LoginSuccessState(this.user);
}

class LoginFailureState extends LoginState {}
