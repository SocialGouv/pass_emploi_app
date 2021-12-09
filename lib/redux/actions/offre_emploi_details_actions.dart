import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';

abstract class OffreEmploiDetailsAction {}

class OffreEmploiDetailsLoadingAction extends OffreEmploiDetailsAction {}

class GetOffreEmploiDetailsAction extends OffreEmploiDetailsAction {
  final String offreId;

  GetOffreEmploiDetailsAction({required this.offreId});
}

class OffreEmploiDetailsSuccessAction extends OffreEmploiDetailsAction {
  final OffreEmploiDetails offre;

  OffreEmploiDetailsSuccessAction(this.offre);
}

class OffreEmploiDetailsFailureAction extends OffreEmploiDetailsAction {}

class OffreEmploiDetailsIncompleteDataAction extends OffreEmploiDetailsAction {
  final OffreEmploi offre;

  OffreEmploiDetailsIncompleteDataAction(this.offre);
}
