import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';

class UserActionUpdateRequestAction {
  final String actionId;
  final UserActionUpdateRequest request;

  UserActionUpdateRequestAction({required this.actionId, required this.request});
}

class UserActionUpdateLoadingAction {}

class UserActionUpdateSuccessAction {
  final String actionId;
  final UserActionUpdateRequest request;

  UserActionUpdateSuccessAction({required this.actionId, required this.request});
}

class UserActionUpdateFailureAction {}

class UserActionUpdateResetAction {}
