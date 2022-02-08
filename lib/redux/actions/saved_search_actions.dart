abstract class SavedSearchAction<T> {}

class RequestPostSavedSearchAction<T> extends SavedSearchAction<T> {
  final T savedSearch;

  RequestPostSavedSearchAction(this.savedSearch);
}

class CreateSavedSearchAction<T> extends SavedSearchAction<T> {
  final T savedSearch;

  CreateSavedSearchAction(this.savedSearch);
}

class SavedSearchFailureAction<T> extends SavedSearchAction<T> {}

class SavedSearchSuccessAction<T> extends SavedSearchAction<T> {}

class InitializeSaveSearchAction<T> extends SavedSearchAction<T> {}