abstract class OffreEmploiFavorisIdState {
  OffreEmploiFavorisIdState._();

  factory OffreEmploiFavorisIdState.notInitialized() = OffreEmploiFavorisIdNotInitialized;

  factory OffreEmploiFavorisIdState.idsLoaded(List<String> offreEmploiFavorisListId) = OffreEmploiFavorisIdLoadedState;
}

class OffreEmploiFavorisIdLoadedState extends OffreEmploiFavorisIdState {
  final List<String> offreEmploiFavorisListId;

  OffreEmploiFavorisIdLoadedState(this.offreEmploiFavorisListId) : super._();
}

class OffreEmploiFavorisIdNotInitialized extends OffreEmploiFavorisIdState {
  OffreEmploiFavorisIdNotInitialized() : super._();
}
