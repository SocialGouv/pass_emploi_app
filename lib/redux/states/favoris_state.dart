abstract class FavorisState<T> {
  FavorisState._();

  factory FavorisState.notInitialized() = FavorisNotInitialized;

  factory FavorisState.idsLoaded(Set<String> favorisListId) => FavorisLoadedState._(null, favorisListId);

  factory FavorisState.withMap(
    Set<String> favorisListId,
    Map<String, T>? favoris,
  ) =>
      FavorisLoadedState._(favoris, favorisListId);
}

class FavorisLoadedState<T> extends FavorisState<T> {
  final Map<String, T>? data;
  final Set<String> favorisId;

  FavorisLoadedState._(this.data, this.favorisId) : super._();
}

class FavorisNotInitialized<T> extends FavorisState<T> {
  FavorisNotInitialized() : super._();
}
