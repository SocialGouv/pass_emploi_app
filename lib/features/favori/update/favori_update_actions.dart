class FavoriUpdateRequestAction<T> {
  final String favoriId;
  final bool newStatus;

  FavoriUpdateRequestAction(this.favoriId, this.newStatus);
}

class FavoriUpdateLoadingAction<T> {
  final String favoriId;

  FavoriUpdateLoadingAction(this.favoriId);
}

class FavoriUpdateSuccessAction<T> {
  final String favoriId;
  final bool confirmedNewStatus;

  FavoriUpdateSuccessAction(this.favoriId, this.confirmedNewStatus);
}

class FavoriUpdateFailureAction<T> {
  final String favoriId;

  FavoriUpdateFailureAction(this.favoriId);
}
