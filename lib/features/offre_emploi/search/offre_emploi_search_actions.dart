import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';

class OffreEmploiSearchRequestAction {
  final String keywords;
  final Location? location;
  final bool onlyAlternance;

  OffreEmploiSearchRequestAction({required this.keywords, required this.location, required this.onlyAlternance});
}

class OffreEmploiSearchLoadingAction {}

class OffreEmploiSearchSuccessAction {
  final List<OffreEmploi> offres;
  final int page;
  final bool isMoreDataAvailable;

  OffreEmploiSearchSuccessAction({required this.offres, required this.page, required this.isMoreDataAvailable});
}

class OffreEmploiSearchFailureAction {}

class OffreEmploiSearchRequestMoreResultsAction {}

class OffreEmploiSearchResetAction {}

class OffreEmploiSearchParametersRequestAction {
  final String keywords;
  final Location? location;
  final bool onlyAlternance;
  final OffreEmploiSearchParametersFiltres filtres;

  OffreEmploiSearchParametersRequestAction({
    required this.keywords,
    required this.location,
    required this.onlyAlternance,
    required this.filtres,
  });
}
