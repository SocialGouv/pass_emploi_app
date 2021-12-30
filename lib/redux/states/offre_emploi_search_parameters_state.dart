import 'package:pass_emploi_app/models/location.dart';

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

class OffreEmploiSearchParametersFiltres {
  final int? distance;

  OffreEmploiSearchParametersFiltres._({
    this.distance,
  });

  factory OffreEmploiSearchParametersFiltres.withFiltres({
    int? distance,
  }) {
    return OffreEmploiSearchParametersFiltres._(
      distance: distance,
    );
  }

  factory OffreEmploiSearchParametersFiltres.noFiltres() {
    return OffreEmploiSearchParametersFiltres._(
      distance: null,
    );
  }
}
