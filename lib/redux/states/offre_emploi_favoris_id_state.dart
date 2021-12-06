import 'package:pass_emploi_app/models/offre_emploi.dart';

abstract class OffreEmploiFavorisIdState {
  OffreEmploiFavorisIdState._();

  factory OffreEmploiFavorisIdState.notInitialized() = OffreEmploiFavorisIdNotInitialized;

  factory OffreEmploiFavorisIdState.withoutData(Set<String> offreEmploiFavorisListId) => OffreEmploiFavorisLoadedState._(
      Map.fromIterable(offreEmploiFavorisListId, key: (offreId) => offreId, value: (_) => null));

  factory OffreEmploiFavorisIdState.withMap(Map<String, OffreEmploi?> offreEmploiFavoris) =>
      OffreEmploiFavorisLoadedState._(offreEmploiFavoris);
}

class OffreEmploiFavorisLoadedState extends OffreEmploiFavorisIdState {
  final Map<String, OffreEmploi?> offreEmploiFavoris;

  OffreEmploiFavorisLoadedState._(this.offreEmploiFavoris) : super._();
}

class OffreEmploiFavorisIdNotInitialized extends OffreEmploiFavorisIdState {
  OffreEmploiFavorisIdNotInitialized() : super._();
}
