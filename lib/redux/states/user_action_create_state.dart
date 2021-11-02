abstract class UserActionCreateState {

  factory UserActionCreateState.notInitialized() => UserActionCreateNotInitializedState();
  factory UserActionCreateState.loading() => CreateUserActionLoadingState();
  factory UserActionCreateState.success() => CreateUserActionSuccessState();

  UserActionCreateState();
}

class UserActionCreateNotInitializedState extends UserActionCreateState {}

class CreateUserActionLoadingState extends UserActionCreateState {}

class CreateUserActionSuccessState extends UserActionCreateState {}