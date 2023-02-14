import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';

class SavedOffreEmploiSearchRequestAction extends Equatable {
  final String keywords;
  final Location? location;
  final bool onlyAlternance;
  final EmploiFiltresRecherche filtres;

  SavedOffreEmploiSearchRequestAction({
    required this.keywords,
    required this.location,
    required this.onlyAlternance,
    required this.filtres,
  });

  factory SavedOffreEmploiSearchRequestAction.fromSearch(OffreEmploiSavedSearch search) {
    return SavedOffreEmploiSearchRequestAction(
      keywords: search.keyword ?? "",
      location: search.location,
      onlyAlternance: search.onlyAlternance,
      filtres: search.filters,
    );
  }

  @override
  List<Object?> get props => [keywords, location, onlyAlternance, filtres];
}
