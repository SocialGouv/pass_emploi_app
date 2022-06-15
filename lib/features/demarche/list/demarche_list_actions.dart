import 'package:pass_emploi_app/models/demarche.dart';

class DemarcheListRequestAction {}

class DemarcheListLoadingAction {}

class DemarcheListSuccessAction {
  final List<Demarche> userActions;
  final bool isDetailAvailable;

  DemarcheListSuccessAction(this.userActions, this.isDetailAvailable);
}

class DemarcheListFailureAction {}

class DemarcheListResetAction {}

// TODO-738 Move to update?
class ModifyDemarcheStatusAction {
  final String id;
  final DateTime? dateFin;
  final DateTime? dateDebut;
  final DemarcheStatus status;

  ModifyDemarcheStatusAction(this.id, this.dateFin, this.dateDebut, this.status);
}

// TODO-738 Move to update?
class DemarcheSuccessUpdateAction {
  final List<Demarche> userActions;

  DemarcheSuccessUpdateAction(this.userActions);
}
