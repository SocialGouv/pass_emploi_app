import 'package:pass_emploi_app/models/location.dart';

import 'package:equatable/equatable.dart';

import '../offre_emploi_filtres_parameters.dart';

class OffreEmploiSavedSearch extends Equatable {
  final String title;
  final String? metier;
  final Location? location;
  final String? keywords;
  final bool isAlternance;
  final OffreEmploiSearchParametersFiltres filters;

  OffreEmploiSavedSearch({
    required this.title,
    required this.metier,
    required this.location,
    required this.keywords,
    required this.isAlternance,
    required this.filters,
  });

  @override
  List<Object?> get props => [title, metier, location, keywords, isAlternance, filters];
}
