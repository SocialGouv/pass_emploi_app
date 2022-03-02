abstract class SavedSearchAction<T> {}

class RequestPostSavedSearchAction<T> extends SavedSearchAction<T> {
  final T savedSearch;
  final String title;

  RequestPostSavedSearchAction(this.savedSearch, this.title);
}

class CreateSavedSearchAction<T> extends SavedSearchAction<T> {
  final T savedSearch;

  CreateSavedSearchAction(this.savedSearch);
}

class SavedSearchFailureAction<T> extends SavedSearchAction<T> {}

class SavedSearchSuccessAction<T> extends SavedSearchAction<T> {
  final T search;

  SavedSearchSuccessAction(this.search);
}

class InitializeSaveSearchAction<T> extends SavedSearchAction<T> {}

class GetSavedSearchAction {
  final String savedSearchId;

  GetSavedSearchAction(this.savedSearchId);
}
