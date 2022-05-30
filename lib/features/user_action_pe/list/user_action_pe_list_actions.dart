import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';

class UserActionPEListRequestAction {}

class UserActionPEListLoadingAction {}

class UserActionPEListSuccessAction {
  final List<UserActionPE> userActions;
  final bool isDetailAvailable;
  final Campagne? campagne;

  UserActionPEListSuccessAction(this.userActions, this.isDetailAvailable, [this.campagne]);
}

class UserActionPEListFailureAction {}

class UserActionPEListResetAction {}

class ModifyDemarcheStatusAction {
  final String id;
  final DateTime? dateDebut;
  final UserActionPEStatus status;

  ModifyDemarcheStatusAction(this.id, this.dateDebut, this.status);
}

class DemarcheSuccessfullyModifiedAction {
  final List<UserActionPE> userActions;

  DemarcheSuccessfullyModifiedAction(this.userActions);
}
