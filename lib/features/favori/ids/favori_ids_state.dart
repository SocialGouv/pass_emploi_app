abstract class FavoriIdsState<T> {
  FavoriIdsState._();

  factory FavoriIdsState.notInitialized() = FavoriIdsNotInitialized;

  factory FavoriIdsState.success(Set<String> favorisListId) => FavoriIdsSuccessState._(favorisListId);

  bool contains(String offreId);
}

class FavoriIdsSuccessState<T> extends FavoriIdsState<T> {
  final Set<String> favoriIds;

  FavoriIdsSuccessState._(this.favoriIds) : super._();

  @override
  bool contains(String offreId) => favoriIds.contains(offreId);
}

class FavoriIdsNotInitialized<T> extends FavoriIdsState<T> {
  FavoriIdsNotInitialized() : super._();

  @override
  bool contains(String offreId) => false;
}
