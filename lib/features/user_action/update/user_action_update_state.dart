import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';

sealed class UserActionUpdateState {}

class UserActionUpdateNotInitializedState extends UserActionUpdateState {}

class UserActionUpdateLoadingState extends UserActionUpdateState {}

class UserActionUpdateSuccessState extends UserActionUpdateState {
  final UserActionUpdateRequest request;

  UserActionUpdateSuccessState(this.request);
}

class UserActionUpdateFailureState extends UserActionUpdateState {}
