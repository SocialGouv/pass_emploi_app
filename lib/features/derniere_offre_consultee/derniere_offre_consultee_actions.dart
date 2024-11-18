import 'package:pass_emploi_app/models/offre_dto.dart';

class DerniereOffreEmploiConsulteeWriteAction {}

class DerniereOffreImmersionConsulteeWriteAction {}

class DerniereOffreServiceCiviqueConsulteeWriteAction {}

class DerniereOffreConsulteeUpdateAction {
  final OffreDto offre;

  DerniereOffreConsulteeUpdateAction(this.offre);
}
