enum SavedSearchCreateStatus { NOT_SENT, LOADING, SUCCESS, ERROR }

abstract class SavedSearchCreateState<T> {
  SavedSearchCreateState();

  abstract SavedSearchCreateStatus status;

  factory SavedSearchCreateState.notInitialized() = SavedSearchCreateNotInitialized;

  factory SavedSearchCreateState.initialized(T search) = SavedSearchCreateInitialized;

  factory SavedSearchCreateState.successfullyCreated() = SavedSearchCreateSuccessfullyCreated;

  factory SavedSearchCreateState.loading() = SavedSearchCreateLoadingState;

  factory SavedSearchCreateState.failure() = SavedSearchCreateFailureState;
}

class SavedSearchCreateNotInitialized<T> extends SavedSearchCreateState<T> {
  @override
  SavedSearchCreateStatus status = SavedSearchCreateStatus.NOT_SENT;
}

class SavedSearchCreateInitialized<T> extends SavedSearchCreateState<T> {
  @override
  SavedSearchCreateStatus status = SavedSearchCreateStatus.NOT_SENT;
  T search;

  SavedSearchCreateInitialized(this.search);
}

class SavedSearchCreateSuccessfullyCreated<T> extends SavedSearchCreateState<T> {
  @override
  SavedSearchCreateStatus status = SavedSearchCreateStatus.SUCCESS;
}

class SavedSearchCreateFailureState<T> extends SavedSearchCreateState<T> {
  @override
  SavedSearchCreateStatus status = SavedSearchCreateStatus.ERROR;
}

class SavedSearchCreateLoadingState<T> extends SavedSearchCreateState<T> {
  @override
  SavedSearchCreateStatus status = SavedSearchCreateStatus.LOADING;
}
