import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';

class UserActionCreateRequestAction {
  final UserActionCreateRequest request;

  UserActionCreateRequestAction(this.request);
}

class UserActionCreateLoadingAction {}

class UserActionCreateSuccessAction {
  final String userActionCreatedId;
  final bool localCreationOnly;

  UserActionCreateSuccessAction(this.userActionCreatedId, {this.localCreationOnly = false});
}

class UserActionCreateFailureAction {}

class UserActionCreateResetAction {}
