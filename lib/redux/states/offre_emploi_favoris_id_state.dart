abstract class OffreEmploiFavorisIdState {
  OffreEmploiFavorisIdState._();

  factory OffreEmploiFavorisIdState.notInitialized() = OffreEmploiFavorisIdNotInitialized;

  factory OffreEmploiFavorisIdState.idsLoaded(Set<String> offreEmploiFavorisListId) = OffreEmploiFavorisIdLoadedState;
}

class OffreEmploiFavorisIdLoadedState extends OffreEmploiFavorisIdState {
  final Set<String> offreEmploiFavorisListId;

  OffreEmploiFavorisIdLoadedState(this.offreEmploiFavorisListId) : super._();
}

class OffreEmploiFavorisIdNotInitialized extends OffreEmploiFavorisIdState {
  OffreEmploiFavorisIdNotInitialized() : super._();
}
