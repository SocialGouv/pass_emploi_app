import 'package:pass_emploi_app/models/user_action.dart';

abstract class UserActionUpdateState {}

class UserActionUpdatedState extends UserActionUpdateState {
  final UserActionStatus newStatus;

  UserActionUpdatedState(this.newStatus);
}

class UserActionNotUpdatingState extends UserActionUpdateState {}

class UserActionNoUpdateNeededState extends UserActionUpdateState {}
