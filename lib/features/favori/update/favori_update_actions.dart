abstract class FavorisAction<T> {}


class UpdateFavoriRequestAction<T> extends FavorisAction<T> {
  final String favoriId;
  final bool newStatus;

  UpdateFavoriRequestAction(this.favoriId, this.newStatus);
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