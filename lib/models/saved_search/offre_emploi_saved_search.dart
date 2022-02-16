import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';

import '../../ui/strings.dart';
import '../offre_emploi_filtres_parameters.dart';

class OffreEmploiSavedSearch extends Equatable {
  final String id;
  final String title;
  final String? metier;
  final Location? location;
  final String? keywords;
  final bool isAlternance;
  final OffreEmploiSearchParametersFiltres filters;

  OffreEmploiSavedSearch({
    required this.id,
    required this.title,
    required this.metier,
    required this.location,
    required this.keywords,
    required this.isAlternance,
    required this.filters,
  });

  String getSavedSearchTagLabel() {
    return isAlternance ? Strings.savedSearchAlternanceTag : Strings.savedSearchEmploiTag;
  }

  OffreEmploiSavedSearch copyWithTitle(String title) {
    return OffreEmploiSavedSearch(
        id: id,
        title: title,
        metier: metier,
        location: location,
        keywords: keywords,
        isAlternance: isAlternance,
        filters: filters);
  }

  @override
  List<Object?> get props => [title, metier, location, keywords, isAlternance, filters];
}
