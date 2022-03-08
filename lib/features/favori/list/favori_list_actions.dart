class FavoriListRequestAction<T> {}

class FavoriListLoadedAction<T> {
  final Map<String, T> favoris;

  FavoriListLoadedAction(this.favoris);
}

class FavoriListFailureAction<T> {}
