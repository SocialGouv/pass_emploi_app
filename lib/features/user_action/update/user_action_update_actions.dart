import 'package:pass_emploi_app/models/user_action.dart';

class UserActionUpdateRequestAction {
  final String userId;
  final String actionId;
  final UserActionStatus newStatus;

  UserActionUpdateRequestAction({required this.userId, required this.actionId, required this.newStatus});
}

class UserActionNoUpdateNeededAction {}

class UserActionUpdateResetAction {}
