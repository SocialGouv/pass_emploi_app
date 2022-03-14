import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

class ImmersionSavedSearch extends Equatable implements SavedSearch {
  final String id;
  final String title;
  final String codeRome;
  final String metier;
  final Location? location;
  final String ville;
  final ImmersionSearchParametersFiltres filtres;

  ImmersionSavedSearch({
    required this.id,
    required this.title,
    required this.codeRome,
    required this.metier,
    required this.location,
    required this.ville,
    required this.filtres,
  });

  ImmersionSavedSearch copyWithTitle(String title) {
    return ImmersionSavedSearch(
      id: id,
      title: title,
      codeRome: codeRome,
      metier: metier,
      location: location,
      ville: ville,
      filtres: filtres,
    );
  }

  @override
  String getId() => id;

  @override
  String getTitle() => title;

  @override
  List<Object?> get props => [id, title, codeRome, metier, location, ville, filtres];
}
