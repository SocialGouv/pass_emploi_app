import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_response.dart';

class AlerteJsonExtractor {
  Alerte? extract(AlerteResponse alerte) {
    if (alerte.type == "OFFRES_IMMERSION") {
      return AlerteImmersionExtractor().extract(alerte);
    } else if (alerte.type == "OFFRES_SERVICES_CIVIQUE") {
      return AlerteServiceCiviqueExtractor().extract(alerte);
    } else if (alerte.type == "OFFRES_EMPLOI" || alerte.type == "OFFRES_ALTERNANCE") {
      return AlerteEmploiExtractor().extract(alerte);
    } else if (alerte.type == "EVENEMENT_EMPLOI") {
      return AlerteEvenementEmploiExtractor().extract(alerte);
    } else {
      return null;
    }
  }
}
