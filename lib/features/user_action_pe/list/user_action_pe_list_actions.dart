import 'package:pass_emploi_app/models/user_action_pe.dart';

class UserActionPEListRequestAction {}

class UserActionPEListLoadingAction {}

class UserActionPEListSuccessAction {
  final List<UserActionPE> userActions;
  final bool isDetailAvailable;

  UserActionPEListSuccessAction(this.userActions, this.isDetailAvailable);
}

class UserActionPEListFailureAction {}

class UserActionPEListResetAction {}

class ModifyDemarcheStatusAction {
  final String id;
  final DateTime? dateFin;
  final DateTime? dateDebut;
  final UserActionPEStatus status;

  ModifyDemarcheStatusAction(this.id, this.dateFin, this.dateDebut, this.status);
}

class DemarcheSuccessfullyModifiedAction {
  final List<UserActionPE> userActions;

  DemarcheSuccessfullyModifiedAction(this.userActions);
}
