abstract class UserActionUpdateState {
  UserActionUpdateState._();

  factory UserActionUpdateState.notUpdating() = UserActionNotUpdatingState;
  factory UserActionUpdateState.updated() => UserActionUpdatedState();
}

class UserActionUpdatedState extends UserActionUpdateState {
  UserActionUpdatedState() : super._();
}

class UserActionNotUpdatingState extends UserActionUpdateState {
  UserActionNotUpdatingState() : super._();
}
