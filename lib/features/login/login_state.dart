import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/user.dart';

sealed class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginNotInitializedState extends LoginState {}

class UserNotLoggedInState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final User user;

  LoginSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

sealed class LoginFailureState extends LoginState {}

class LoginGenericFailureState extends LoginFailureState {
  final String message;

  LoginGenericFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginWrongDeviceClockState extends LoginFailureState {}
