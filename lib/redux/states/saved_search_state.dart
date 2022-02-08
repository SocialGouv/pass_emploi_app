abstract class SavedSearchState<T> {
  SavedSearchState();

  factory SavedSearchState.notInitialized() = SavedSearchNotInitialized;
  factory SavedSearchState.initialized(T search) = SavedSearchInitialized;
  factory SavedSearchState.successfullyCreated() = SavedSearchSuccessfullyCreated;
  factory SavedSearchState.loading() = SavedSearchLoadingState;
  factory SavedSearchState.failure() = SavedSearchFailureState;
}

class SavedSearchNotInitialized<T> extends SavedSearchState<T> {}

class SavedSearchInitialized<T> extends SavedSearchState<T> {
  T search;

  SavedSearchInitialized(this.search);
}

class SavedSearchSuccessfullyCreated<T> extends SavedSearchState<T> {}

class SavedSearchFailureState<T> extends SavedSearchState<T> {}

class SavedSearchLoadingState<T> extends SavedSearchState<T> {}