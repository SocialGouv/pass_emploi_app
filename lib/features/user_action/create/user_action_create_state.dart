abstract class UserActionCreateState {}

class UserActionCreateNotInitializedState extends UserActionCreateState {}

class UserActionCreateLoadingState extends UserActionCreateState {}

class UserActionCreateSuccessState extends UserActionCreateState {
  final String userActionCreatedId;

  UserActionCreateSuccessState(this.userActionCreatedId);
}

class UserActionCreateFailureState extends UserActionCreateState {}
