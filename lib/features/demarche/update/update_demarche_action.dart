import 'package:pass_emploi_app/models/demarche.dart';

class UpdateDemarcheAction {
  final String id;
  final DateTime? dateFin;
  final DateTime? dateDebut;
  final DemarcheStatus status;

  UpdateDemarcheAction(this.id, this.dateFin, this.dateDebut, this.status);
}
