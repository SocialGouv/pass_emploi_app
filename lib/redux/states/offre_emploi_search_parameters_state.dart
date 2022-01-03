import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';

abstract class OffreEmploiSearchParametersState {
  OffreEmploiSearchParametersState._();

  factory OffreEmploiSearchParametersState.initialized(
    String keyWords,
    Location? location,
    OffreEmploiSearchParametersFiltres filtres,
  ) =>
      OffreEmploiSearchParametersInitializedState(keyWords: keyWords, location: location, filtres: filtres);

  factory OffreEmploiSearchParametersState.notInitialized() = OffreEmploiSearchParametersStateNotInitializedState;
}

class OffreEmploiSearchParametersInitializedState extends OffreEmploiSearchParametersState {
  final String keyWords;
  final Location? location;
  final OffreEmploiSearchParametersFiltres filtres;

  OffreEmploiSearchParametersInitializedState({
    required this.keyWords,
    required this.location,
    required this.filtres,
  }) : super._();
}

class OffreEmploiSearchParametersStateNotInitializedState extends OffreEmploiSearchParametersState {
  OffreEmploiSearchParametersStateNotInitializedState() : super._();
}
