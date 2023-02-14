import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
//TODO(1418): à supprimer ?
abstract class OffreEmploiSearchParametersState {
  OffreEmploiSearchParametersState._();

  factory OffreEmploiSearchParametersState.initialized({
    required String keywords,
    required Location? location,
    required bool onlyAlternance,
    required OffreEmploiSearchParametersFiltres filtres,
  }) {
    return OffreEmploiSearchParametersInitializedState(
      keywords: keywords,
      location: location,
      onlyAlternance: onlyAlternance,
      filtres: filtres,
    );
  }

  factory OffreEmploiSearchParametersState.notInitialized() = OffreEmploiSearchParametersStateNotInitializedState;
}

class OffreEmploiSearchParametersInitializedState extends OffreEmploiSearchParametersState {
  final String keywords;
  final Location? location;
  final bool onlyAlternance;
  final OffreEmploiSearchParametersFiltres filtres;

  OffreEmploiSearchParametersInitializedState({
    required this.keywords,
    required this.location,
    required this.onlyAlternance,
    required this.filtres,
  }) : super._();
}

class OffreEmploiSearchParametersStateNotInitializedState extends OffreEmploiSearchParametersState {
  OffreEmploiSearchParametersStateNotInitializedState() : super._();
}
