abstract class OffreEmploiFavorisAction {}

class OffreEmploisFavorisIdLoadedAction extends OffreEmploiFavorisAction {
  final List<String> favorisId;

  OffreEmploisFavorisIdLoadedAction(this.favorisId);
}