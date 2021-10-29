abstract class UserActionCreateState {

  factory UserActionCreateState.notInitialized() => UserActionCreateNotInitializedState();
  factory UserActionCreateState.loading() => CreateUserActionLoadingState();

  UserActionCreateState();
}

class UserActionCreateNotInitializedState extends UserActionCreateState {}

class CreateUserActionLoadingState extends UserActionCreateState {}