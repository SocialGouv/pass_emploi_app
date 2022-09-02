import 'package:pass_emploi_app/models/user_action.dart';

class UserActionUpdateRequestAction {
  final String actionId;
  final UserActionStatus newStatus;

  UserActionUpdateRequestAction({required this.actionId, required this.newStatus});
}

class UserActionUpdateLoadingAction {}

class UserActionUpdateSuccessAction {
  final String actionId;
  final UserActionStatus newStatus;

  UserActionUpdateSuccessAction({required this.actionId, required this.newStatus});
}

class UserActionUpdateFailureAction {}

class UserActionUpdateResetAction {}

