abstract class CreateUserActionState {

  factory CreateUserActionState.notInitialized() => CreateUserActionNotInitializedState();
  factory CreateUserActionState.loading() => CreateUserActionLoadingState();
  factory CreateUserActionState.success() => CreateUserActionSuccessState();
  factory CreateUserActionState.error() => CreateUserActionErrorState();

  CreateUserActionState();
}

class CreateUserActionNotInitializedState extends CreateUserActionState {}

class CreateUserActionLoadingState extends CreateUserActionState {}

class CreateUserActionSuccessState extends CreateUserActionState {}

class CreateUserActionErrorState extends CreateUserActionState {}