abstract class UserActionDeleteState {
  UserActionDeleteState._();

  factory UserActionDeleteState.notInitialized() = UserActionDeleteNotInitializedState;

  factory UserActionDeleteState.loading() = UserActionDeleteLoadingState;

  factory UserActionDeleteState.success() = UserActionDeleteSuccessState;

  factory UserActionDeleteState.failure() = UserActionDeleteFailureState;
}

class UserActionDeleteLoadingState extends UserActionDeleteState {
  UserActionDeleteLoadingState() : super._();
}

class UserActionDeleteSuccessState extends UserActionDeleteState {
  UserActionDeleteSuccessState() : super._();
}

class UserActionDeleteFailureState extends UserActionDeleteState {
  UserActionDeleteFailureState() : super._();
}

class UserActionDeleteNotInitializedState extends UserActionDeleteState {
  UserActionDeleteNotInitializedState() : super._();
}
