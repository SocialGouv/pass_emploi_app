abstract class UserActionUpdateState {
  UserActionUpdateState._();

  factory UserActionUpdateState.notUpdating() = UserActionNotUpdatingState;
  factory UserActionUpdateState.updated() => UserActionUpdatedState();

  factory UserActionUpdateState.noUpdateNeeded() = UserActionNoUpdateNeeded;
}

class UserActionUpdatedState extends UserActionUpdateState {
  UserActionUpdatedState() : super._();
}

class UserActionNotUpdatingState extends UserActionUpdateState {
  UserActionNotUpdatingState() : super._();
}

class UserActionNoUpdateNeeded extends UserActionUpdateState {
  UserActionNoUpdateNeeded() : super._();
}
