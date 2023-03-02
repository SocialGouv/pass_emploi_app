abstract class FavoriIdsState<T> {
  FavoriIdsState._();

  factory FavoriIdsState.notInitialized() = FavoriIdsNotInitialized;

  factory FavoriIdsState.success(Set<String> favorisListId) => FavoriIdsSuccessState._(favorisListId);
}

class FavoriIdsSuccessState<T> extends FavoriIdsState<T> {
  final Set<String> favoriIds;

  FavoriIdsSuccessState._(this.favoriIds) : super._();
}

class FavoriIdsNotInitialized<T> extends FavoriIdsState<T> {
  FavoriIdsNotInitialized() : super._();
}
