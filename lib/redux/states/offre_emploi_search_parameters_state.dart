import 'package:pass_emploi_app/models/location.dart';

abstract class OffreEmploiSearchParametersState {
  OffreEmploiSearchParametersState._();

  factory OffreEmploiSearchParametersState.initialized(String keyWords, Location? location) =>
      OffreEmploiSearchParametersInitializedState(keyWords: keyWords, location: location);

  factory OffreEmploiSearchParametersState.notInitialized() = OffreEmploiSearchParametersStateNotInitializedState;
}

class OffreEmploiSearchParametersInitializedState extends OffreEmploiSearchParametersState {
  final String keyWords;
  final Location? location;
  final Map<String, String> filters;

  OffreEmploiSearchParametersInitializedState({
    required this.keyWords,
    required this.location,
    this.filters = const {},
  }) : super._();
}

class OffreEmploiSearchParametersStateNotInitializedState extends OffreEmploiSearchParametersState {
  OffreEmploiSearchParametersStateNotInitializedState() : super._();
}
