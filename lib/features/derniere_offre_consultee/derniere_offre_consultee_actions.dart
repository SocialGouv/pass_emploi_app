import 'package:pass_emploi_app/models/derniere_offre_consultee.dart';

class DerniereOffreEmploiConsulteeWriteAction {}

class DerniereOffreImmersionConsulteeWriteAction {}

class DerniereOffreServiceCiviqueConsulteeWriteAction {}

class DerniereOffreConsulteeUpdateAction {
  final DerniereOffreConsultee offre;

  DerniereOffreConsulteeUpdateAction(this.offre);
}
