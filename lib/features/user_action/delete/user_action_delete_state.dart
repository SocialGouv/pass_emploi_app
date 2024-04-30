sealed class UserActionDeleteState {}

class UserActionDeleteNotInitializedState extends UserActionDeleteState {}

class UserActionDeleteLoadingState extends UserActionDeleteState {}

class UserActionDeleteSuccessState extends UserActionDeleteState {}

class UserActionDeleteFailureState extends UserActionDeleteState {}
