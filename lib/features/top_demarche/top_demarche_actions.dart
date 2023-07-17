import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';

class TopDemarcheRequestAction {}

class TopDemarcheSuccessAction {
  final List<DemarcheDuReferentiel> demarches;

  TopDemarcheSuccessAction(this.demarches);
}
