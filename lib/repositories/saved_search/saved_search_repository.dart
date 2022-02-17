abstract class SavedSearchRepository<SavedSearch> {
  Future<bool> postSavedSearch(String userId, SavedSearch savedSearch, String title);
}
