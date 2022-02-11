abstract class SavedSearchState<T> {
  SavedSearchState();

  abstract SavedSearchStatus status;

  factory SavedSearchState.notInitialized() = SavedSearchNotInitialized;

  factory SavedSearchState.initialized(T search) = SavedSearchInitialized;

  factory SavedSearchState.successfullyCreated() = SavedSearchSuccessfullyCreated;

  factory SavedSearchState.loading() = SavedSearchLoadingState;

  factory SavedSearchState.failure() = SavedSearchFailureState;
}

enum SavedSearchStatus { NOT_SENT, LOADING, SUCCESS, ERROR }

class SavedSearchNotInitialized<T> extends SavedSearchState<T> {
  SavedSearchStatus status = SavedSearchStatus.NOT_SENT;
}

class SavedSearchInitialized<T> extends SavedSearchState<T> {
  SavedSearchStatus status = SavedSearchStatus.NOT_SENT;
  T search;

  SavedSearchInitialized(this.search);
}

class SavedSearchSuccessfullyCreated<T> extends SavedSearchState<T> {
  SavedSearchStatus status = SavedSearchStatus.SUCCESS;
}

class SavedSearchFailureState<T> extends SavedSearchState<T> {
  SavedSearchStatus status = SavedSearchStatus.ERROR;
}

class SavedSearchLoadingState<T> extends SavedSearchState<T> {
  SavedSearchStatus status = SavedSearchStatus.LOADING;
}