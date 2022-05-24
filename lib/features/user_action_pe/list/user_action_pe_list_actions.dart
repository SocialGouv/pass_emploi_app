import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';

class UserActionPEListRequestAction {}

class UserActionPEListLoadingAction {}

class UserActionPEListSuccessAction {
  final List<UserActionPE> userActions;
  final Campagne? campagne;

  UserActionPEListSuccessAction(this.userActions, [this.campagne]);
}

class UserActionPEListFailureAction {}

class UserActionPEListResetAction {}
