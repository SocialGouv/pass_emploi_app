import 'package:pass_emploi_app/models/offre_emploi.dart';

abstract class OffreEmploiFavorisAction {}

class OffreEmploisFavorisIdLoadedAction extends OffreEmploiFavorisAction {
  final Set<String> favorisId;

  OffreEmploisFavorisIdLoadedAction(this.favorisId);
}

class OffreEmploiRequestUpdateFavoriAction extends OffreEmploiFavorisAction {
  final String offreId;
  final bool newStatus;

  OffreEmploiRequestUpdateFavoriAction(this.offreId, this.newStatus);
}


class OffreEmploiUpdateFavoriLoadingAction extends OffreEmploiFavorisAction {
  final String offreId;

  OffreEmploiUpdateFavoriLoadingAction(this.offreId);
}


class OffreEmploiUpdateFavoriSuccessAction extends OffreEmploiFavorisAction {
  final String offreId;
  final bool confirmedNewStatus;

  OffreEmploiUpdateFavoriSuccessAction(this.offreId, this.confirmedNewStatus);
}

class OffreEmploiUpdateFavoriFailureAction extends OffreEmploiFavorisAction {
  final String offreId;

  OffreEmploiUpdateFavoriFailureAction(this.offreId);
}

class RequestOffreEmploiFavorisAction extends OffreEmploiFavorisAction {}

class OffreEmploisFavorisLoadedAction extends OffreEmploiFavorisAction {
  final Map<String, OffreEmploi> favoris;

  OffreEmploisFavorisLoadedAction(this.favoris);
}

class OffreEmploisFavorisFailureAction extends OffreEmploiFavorisAction {}
