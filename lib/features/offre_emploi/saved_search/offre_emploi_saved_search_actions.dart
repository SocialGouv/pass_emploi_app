import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';

class SavedOffreEmploiSearchRequestAction extends Equatable {
  final String keywords;
  final Location? location;
  final bool onlyAlternance;
  final OffreEmploiSearchParametersFiltres filtres;

  SavedOffreEmploiSearchRequestAction({
    required this.keywords,
    required this.location,
    required this.onlyAlternance,
    required this.filtres,
  });

  @override
  List<Object?> get props => [keywords, location, onlyAlternance, filtres];
}
