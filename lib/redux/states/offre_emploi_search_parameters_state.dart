abstract class OffreEmploiSearchParametersState {
  OffreEmploiSearchParametersState._();

  factory OffreEmploiSearchParametersState.initialized(String? keyWords, String? department) =
      OffreEmploiSearchParametersInitializedState;

  factory OffreEmploiSearchParametersState.notInitialized() = OffreEmploiSearchParametersStateNotInitializedState;
}

class OffreEmploiSearchParametersInitializedState extends OffreEmploiSearchParametersState {
  final String? keyWords;
  final String? department;

  OffreEmploiSearchParametersInitializedState(this.keyWords, this.department) : super._();
}

class OffreEmploiSearchParametersStateNotInitializedState extends OffreEmploiSearchParametersState {
  OffreEmploiSearchParametersStateNotInitializedState() : super._();
}
