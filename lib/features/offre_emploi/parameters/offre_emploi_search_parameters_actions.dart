import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';

class OffreEmploiSearchParametersUpdateFiltresRequestAction {
  final EmploiFiltresRecherche updatedFiltres;

  OffreEmploiSearchParametersUpdateFiltresRequestAction(this.updatedFiltres);
}

class OffreEmploiSearchParametersUpdateFiltresSuccessAction {
  final List<OffreEmploi> offres;
  final int page;
  final bool isMoreDataAvailable;

  OffreEmploiSearchParametersUpdateFiltresSuccessAction({
    required this.offres,
    required this.page,
    required this.isMoreDataAvailable,
  });
}

class OffreEmploiSearchParametersUpdateFiltresFailureAction {}
