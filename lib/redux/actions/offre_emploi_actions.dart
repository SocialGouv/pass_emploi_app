import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';

abstract class OffreEmploiAction {}

class SearchOffreEmploiAction extends OffreEmploiAction {
  final String keywords;
  final Location? location;
  final bool onlyAlternance;

  SearchOffreEmploiAction({required this.keywords, required this.location, required this.onlyAlternance});
}

class OffreEmploiSearchLoadingAction extends OffreEmploiAction {}

class OffreEmploiSearchSuccessAction extends OffreEmploiAction {
  final List<OffreEmploi> offres;
  final int page;
  final bool isMoreDataAvailable;

  OffreEmploiSearchSuccessAction({required this.offres, required this.page, required this.isMoreDataAvailable});
}

class OffreEmploiSearchFailureAction extends OffreEmploiAction {}

class RequestMoreOffreEmploiSearchResultsAction extends OffreEmploiAction {}

class OffreEmploiResetResultsAction extends OffreEmploiAction {}

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