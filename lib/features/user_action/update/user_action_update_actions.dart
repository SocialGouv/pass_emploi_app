import 'package:pass_emploi_app/models/user_action.dart';

class UserActionUpdateRequestAction {
  final String actionId;
  final UserActionStatus newStatus;

  UserActionUpdateRequestAction({required this.actionId, required this.newStatus});
}

class UserActionUpdateNeededAction {
  final String actionId;
  final UserActionStatus newStatus;

  UserActionUpdateNeededAction({required this.actionId, required this.newStatus});
}

class UserActionNoUpdateNeededAction {}

class UserActionUpdateResetAction {}
