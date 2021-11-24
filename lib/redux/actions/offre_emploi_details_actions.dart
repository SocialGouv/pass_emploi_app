import 'package:pass_emploi_app/models/detailed_offer.dart';

abstract class OffreEmploiDetailsAction {}

class OffreEmploiDetailsLoadingAction extends OffreEmploiDetailsAction {}

class GetOffreEmploiDetailsAction extends OffreEmploiDetailsAction {
  final String offreId;

  GetOffreEmploiDetailsAction({required this.offreId});
}

class OffreEmploiDetailsSuccessAction extends OffreEmploiDetailsAction {
  final DetailedOffer offre;

  OffreEmploiDetailsSuccessAction(this.offre);
}

class OffreEmploiDetailsFailureAction extends OffreEmploiDetailsAction {}
