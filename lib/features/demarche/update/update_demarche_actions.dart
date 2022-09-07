import 'package:pass_emploi_app/models/demarche.dart';

class UpdateDemarcheRequestAction {
  final String id;
  final DateTime? dateFin;
  final DateTime? dateDebut;
  final DemarcheStatus status;

  UpdateDemarcheRequestAction(this.id, this.dateFin, this.dateDebut, this.status);
}

class UpdateDemarcheLoadingAction {}

class UpdateDemarcheSuccessAction {
  final Demarche modifiedDemarche;

  UpdateDemarcheSuccessAction(this.modifiedDemarche);
}

class UpdateDemarcheFailureAction {}

class UpdateDemarcheResetAction {}