import 'package:pass_emploi_app/models/home.dart';

abstract class UserActionState {
  UserActionState._();

  factory UserActionState.loading() = UserActionLoadingState;

  factory UserActionState.success(Home home) = UserActionSuccessState;

  factory UserActionState.failure() = UserActionFailureState;

  factory UserActionState.notInitialized() = UserActionNotInitializedState;
}

class UserActionLoadingState extends UserActionState {
  UserActionLoadingState() : super._();
}

class UserActionSuccessState extends UserActionState {
  final Home home;

  UserActionSuccessState(this.home) : super._();
}

class UserActionFailureState extends UserActionState {
  UserActionFailureState() : super._();
}

class UserActionNotInitializedState extends UserActionState {
  UserActionNotInitializedState() : super._();
}
