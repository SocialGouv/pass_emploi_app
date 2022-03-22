class SavedSearchCreateRequestAction<T> {
  final T savedSearch;
  final String title;

  SavedSearchCreateRequestAction(this.savedSearch, this.title);
}

class SavedSearchCreateInitializeAction<T> {
  final T savedSearch;

  SavedSearchCreateInitializeAction(this.savedSearch);
}

class SavedSearchCreateLoadingAction<T> {}

class SavedSearchCreateSuccessAction<T> {
  final T search;

  SavedSearchCreateSuccessAction(this.search);
}

class SavedSearchCreateFailureAction<T> {}

class SavedSearchCreateResetAction<T> {}
