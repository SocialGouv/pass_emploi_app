import 'package:pass_emploi_app/models/offre_emploi.dart';

abstract class OffreEmploiFavorisState {
  OffreEmploiFavorisState._();

  factory OffreEmploiFavorisState.notInitialized() = OffreEmploiFavorisNotInitialized;

  factory OffreEmploiFavorisState.onlyIds(Set<String> offreEmploiFavorisListId) =>
      OffreEmploiFavorisLoadedState._(null, offreEmploiFavorisListId);

  factory OffreEmploiFavorisState.withMap(
    Set<String> offreEmploiFavorisListId,
    Map<String, OffreEmploi>? offreEmploiFavoris,
  ) =>
      OffreEmploiFavorisLoadedState._(offreEmploiFavoris, offreEmploiFavorisListId);
}

class OffreEmploiFavorisLoadedState extends OffreEmploiFavorisState {
  final Map<String, OffreEmploi>? data;
  final Set<String> offreEmploiFavorisId;

  OffreEmploiFavorisLoadedState._(this.data, this.offreEmploiFavorisId) : super._();
}

class OffreEmploiFavorisNotInitialized extends OffreEmploiFavorisState {
  OffreEmploiFavorisNotInitialized() : super._();
}
