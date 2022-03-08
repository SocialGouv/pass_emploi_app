import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';

abstract class OffreEmploiAction {}

class OffreEmploiSearchUpdateFiltresAction extends OffreEmploiAction {
  final OffreEmploiSearchParametersFiltres updatedFiltres;

  OffreEmploiSearchUpdateFiltresAction(this.updatedFiltres);
}

class OffreEmploiSearchWithUpdateFiltresSuccessAction extends OffreEmploiAction {
  final List<OffreEmploi> offres;
  final int page;
  final bool isMoreDataAvailable;

  OffreEmploiSearchWithUpdateFiltresSuccessAction({
    required this.offres,
    required this.page,
    required this.isMoreDataAvailable,
  });
}

class OffreEmploiSearchWithUpdateFiltresFailureAction extends OffreEmploiAction {}

class OffreEmploiSearchWithFiltresAction extends OffreEmploiAction {
  final String keywords;
  final Location? location;
  final bool onlyAlternance;
  final OffreEmploiSearchParametersFiltres updatedFiltres;

  OffreEmploiSearchWithFiltresAction({
    required this.keywords,
    required this.location,
    required this.onlyAlternance,
    required this.updatedFiltres,
  });
}
