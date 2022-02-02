abstract class SavedSearchRepository<T> {
  Future<bool> postSavedSearch(String userId, T savedSearch);
}
