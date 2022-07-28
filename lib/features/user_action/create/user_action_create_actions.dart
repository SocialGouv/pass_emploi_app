import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';

class UserActionCreateRequestAction {
  final UserActionCreateRequest request;

  UserActionCreateRequestAction(this.request);
}

class UserActionCreateLoadingAction {}

class UserActionCreateSuccessAction {}

class UserActionCreateFailureAction {}

class UserActionCreateResetAction {}
