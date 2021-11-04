import 'package:pass_emploi_app/models/user_action.dart';

abstract class UserActionState {
  UserActionState._();

  factory UserActionState.loading() = UserActionLoadingState;

  factory UserActionState.success(List<UserAction> actions) = UserActionSuccessState;

  factory UserActionState.failure() = UserActionFailureState;

  factory UserActionState.notInitialized() = UserActionNotInitializedState;

}

class UserActionLoadingState extends UserActionState {
  UserActionLoadingState() : super._();
}

class UserActionSuccessState extends UserActionState {
  final List<UserAction> actions;

  UserActionSuccessState(this.actions) : super._();
}

class UserActionFailureState extends UserActionState {
  UserActionFailureState() : super._();
}

class UserActionNotInitializedState extends UserActionState {
  UserActionNotInitializedState() : super._();
}
