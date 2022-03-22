import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';

class OffreEmploiDetailsRequestAction {
  final String offreId;

  OffreEmploiDetailsRequestAction(this.offreId);
}

class OffreEmploiDetailsLoadingAction {}

class OffreEmploiDetailsSuccessAction {
  final OffreEmploiDetails offre;

  OffreEmploiDetailsSuccessAction(this.offre);
}

class OffreEmploiDetailsIncompleteDataAction {
  final OffreEmploi offre;

  OffreEmploiDetailsIncompleteDataAction(this.offre);
}

class OffreEmploiDetailsFailureAction {}

class OffreEmploiDetailsResetAction {}
