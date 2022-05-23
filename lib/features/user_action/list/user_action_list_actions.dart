import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/user_action.dart';

class UserActionListRequestAction {}

class UserActionListLoadingAction {}

class UserActionListSuccessAction {
  final List<UserAction> userActions;
  final Campagne? campagne;

  UserActionListSuccessAction(this.userActions, [this.campagne]);
}

class UserActionListFailureAction {}

class UserActionListResetAction {}
