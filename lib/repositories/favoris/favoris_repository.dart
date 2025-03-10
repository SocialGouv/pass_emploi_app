abstract class FavorisRepository<T> {
  Future<Set<String>?> getFavorisId(String userId);

  Future<bool> postFavori(String userId, T favori, {bool postulated = false});

  Future<bool> deleteFavori(String userId, String favoriId);
}
