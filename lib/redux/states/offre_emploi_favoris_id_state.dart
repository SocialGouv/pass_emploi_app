import 'package:pass_emploi_app/models/offre_emploi.dart';

abstract class OffreEmploiFavorisState {
  OffreEmploiFavorisState._();

  factory OffreEmploiFavorisState.notInitialized() = OffreEmploiFavorisNotInitialized;

  factory OffreEmploiFavorisState.withoutData(Set<String> offreEmploiFavorisListId) => OffreEmploiFavorisLoadedState._(
      Map.fromIterable(offreEmploiFavorisListId, key: (offreId) => offreId, value: (_) => null));

  factory OffreEmploiFavorisState.withMap(Map<String, OffreEmploi?> offreEmploiFavoris) =>
      OffreEmploiFavorisLoadedState._(offreEmploiFavoris);
}

class OffreEmploiFavorisLoadedState extends OffreEmploiFavorisState {
  final Map<String, OffreEmploi?> offreEmploiFavoris;

  OffreEmploiFavorisLoadedState._(this.offreEmploiFavoris) : super._();
}

class OffreEmploiFavorisNotInitialized extends OffreEmploiFavorisState {
  OffreEmploiFavorisNotInitialized() : super._();
}
