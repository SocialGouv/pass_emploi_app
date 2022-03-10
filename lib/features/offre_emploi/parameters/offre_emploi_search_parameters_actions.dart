import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';

class OffreEmploiSearchParametersUpdateFiltresRequestAction {
  final OffreEmploiSearchParametersFiltres updatedFiltres;

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
