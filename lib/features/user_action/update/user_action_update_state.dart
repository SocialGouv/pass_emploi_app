import 'package:pass_emploi_app/models/user_action.dart';

abstract class UserActionUpdateState {}

class UserActionUpdateNotInitializedState extends UserActionUpdateState {}

class UserActionUpdateLoadingState extends UserActionUpdateState {}

class UserActionUpdateSuccessState extends UserActionUpdateState {
  final UserActionStatus newStatus;

  UserActionUpdateSuccessState(this.newStatus);
}

class UserActionUpdateFailureState extends UserActionUpdateState {}
