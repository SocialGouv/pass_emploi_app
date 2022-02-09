import 'package:pass_emploi_app/models/user_action.dart';

abstract class UserActionUpdateState {
  UserActionUpdateState._();

  factory UserActionUpdateState.notUpdating() = UserActionNotUpdatingState;

  factory UserActionUpdateState.updated(UserActionStatus newStatus) = UserActionUpdatedState;

  factory UserActionUpdateState.noUpdateNeeded() = UserActionNoUpdateNeeded;
}

class UserActionUpdatedState extends UserActionUpdateState {
  final UserActionStatus newStatus;

  UserActionUpdatedState(this.newStatus) : super._();
}

class UserActionNotUpdatingState extends UserActionUpdateState {
  UserActionNotUpdatingState() : super._();
}

class UserActionNoUpdateNeeded extends UserActionUpdateState {
  UserActionNoUpdateNeeded() : super._();
}
