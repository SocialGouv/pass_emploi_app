import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class OffreEmploiSavedSearch extends Equatable implements SavedSearch {
  final String id;
  final String title;
  final String? metier;
  final Location? location;
  final String? keyword;
  final bool onlyAlternance;
  final EmploiFiltresRecherche filters;

  OffreEmploiSavedSearch({
    required this.id,
    required this.title,
    required this.metier,
    required this.location,
    required this.keyword,
    required this.onlyAlternance,
    required this.filters,
  });

  String getSavedSearchTagLabel() {
    return onlyAlternance ? Strings.savedSearchAlternanceTag : Strings.savedSearchEmploiTag;
  }

  OffreEmploiSavedSearch copyWithTitle(String title) {
    return OffreEmploiSavedSearch(
      id: id,
      title: title,
      metier: metier,
      location: location,
      keyword: keyword,
      onlyAlternance: onlyAlternance,
      filters: filters,
    );
  }

  @override
  String getId() => id;

  @override
  String getTitle() => title;

  @override
  List<Object?> get props => [id, title, metier, location, keyword, onlyAlternance, filters];
}
