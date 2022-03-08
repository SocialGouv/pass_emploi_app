abstract class FavoriListState<T> {
  FavoriListState._();

  factory FavoriListState.notInitialized() = FavoriListNotInitialized;

  factory FavoriListState.idsLoaded(Set<String> favorisListId) => FavoriListLoadedState._(null, favorisListId);

  factory FavoriListState.withMap(Set<String> favorisListId, Map<String, T>? favoris) {
    return FavoriListLoadedState._(favoris, favorisListId);
  }
}

class FavoriListLoadedState<T> extends FavoriListState<T> {
  final Map<String, T>? data;
  final Set<String> favoriIds;

  FavoriListLoadedState._(this.data, this.favoriIds) : super._();
}

class FavoriListNotInitialized<T> extends FavoriListState<T> {
  FavoriListNotInitialized() : super._();
}
