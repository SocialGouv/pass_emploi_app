import 'package:pass_emploi_app/models/offre_emploi.dart';

abstract class OffreEmploiAction {}

class SearchOffreEmploiAction extends OffreEmploiAction {
  final String keywords;
  final String department;

  SearchOffreEmploiAction({required this.keywords, required this.department});
}

class OffreEmploiSearchLoadingAction extends OffreEmploiAction {}

class OffreEmploiSearchSuccessAction extends OffreEmploiAction {
  final List<OffreEmploi> offres;
  final int page;

  OffreEmploiSearchSuccessAction({required this.offres, required this.page});
}

class OffreEmploiSearchFailureAction extends OffreEmploiAction {}

class RequestMoreOffreEmploiSearchResultsAction extends OffreEmploiAction {}
