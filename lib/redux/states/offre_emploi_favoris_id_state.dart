import 'package:pass_emploi_app/models/offre_emploi.dart';

abstract class OffreEmploiFavorisIdState {
  OffreEmploiFavorisIdState._();

  factory OffreEmploiFavorisIdState.notInitialized() = OffreEmploiFavorisIdNotInitialized;

  factory OffreEmploiFavorisIdState.idsLoaded(Set<String> offreEmploiFavorisListId) => OffreEmploiFavorisLoadedState(
      Map.fromIterable(offreEmploiFavorisListId, key: (offreId) => offreId, value: (_) => null));
}

class OffreEmploiFavorisLoadedState extends OffreEmploiFavorisIdState {
  final Map<String, OffreEmploi?> offreEmploiFavoris;

  OffreEmploiFavorisLoadedState(this.offreEmploiFavoris) : super._();
}

class OffreEmploiFavorisIdNotInitialized extends OffreEmploiFavorisIdState {
  OffreEmploiFavorisIdNotInitialized() : super._();
}
