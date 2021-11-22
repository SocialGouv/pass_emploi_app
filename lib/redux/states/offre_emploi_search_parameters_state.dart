abstract class OffreEmploiSearchParametersState {
  OffreEmploiSearchParametersState._();

  factory OffreEmploiSearchParametersState.initialized(String keyWords, String department) =>
      OffreEmploiSearchParametersInitializedState(keyWords: keyWords, department: department);

  factory OffreEmploiSearchParametersState.notInitialized() = OffreEmploiSearchParametersStateNotInitializedState;
}

class OffreEmploiSearchParametersInitializedState extends OffreEmploiSearchParametersState {
  final String keyWords;
  final String department;

  OffreEmploiSearchParametersInitializedState({required this.keyWords, required this.department}) : super._();
}

class OffreEmploiSearchParametersStateNotInitializedState extends OffreEmploiSearchParametersState {
  OffreEmploiSearchParametersStateNotInitializedState() : super._();
}
