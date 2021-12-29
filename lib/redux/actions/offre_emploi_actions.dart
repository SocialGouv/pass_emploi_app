import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';

abstract class OffreEmploiAction {}

class SearchOffreEmploiAction extends OffreEmploiAction {
  final String keywords;
  final Location? location;

  SearchOffreEmploiAction({required this.keywords, required this.location});
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