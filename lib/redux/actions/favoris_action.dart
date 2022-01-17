abstract class FavorisAction<T> {}

class FavorisIdLoadedAction<T> extends FavorisAction<T> {
  final Set<String> favorisId;

  FavorisIdLoadedAction(this.favorisId);
}

class RequestUpdateFavoriAction<T> extends FavorisAction<T> {
  final String favoriId;
  final bool newStatus;

  RequestUpdateFavoriAction(this.favoriId, this.newStatus);
}

class UpdateFavoriLoadingAction<T> extends FavorisAction<T> {
  final String favoriId;

  UpdateFavoriLoadingAction(this.favoriId);
}

class UpdateFavoriSuccessAction<T> extends FavorisAction<T> {
  final String favoriId;
  final bool confirmedNewStatus;

  UpdateFavoriSuccessAction(this.favoriId, this.confirmedNewStatus);
}

class UpdateFavoriFailureAction<T> extends FavorisAction<T> {
  final String favoriId;

  UpdateFavoriFailureAction(this.favoriId);
}

class RequestFavorisAction<T> extends FavorisAction<T> {}

class FavorisLoadedAction<T> extends FavorisAction<T> {
  final Map<String, T> favoris;

  FavorisLoadedAction(this.favoris);
}

class FavorisFailureAction<T> extends FavorisAction<T> {}
