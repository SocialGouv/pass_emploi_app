abstract class SavedSearchDeleteState {
  SavedSearchDeleteState._();

  factory SavedSearchDeleteState.notInitialized() = SavedSearchDeleteNotInitializedState;

  factory SavedSearchDeleteState.loading() = SavedSearchDeleteLoadingState;

  factory SavedSearchDeleteState.success() = SavedSearchDeleteSuccessState;

  factory SavedSearchDeleteState.failure() = SavedSearchDeleteFailureState;
}

class SavedSearchDeleteLoadingState extends SavedSearchDeleteState {
  SavedSearchDeleteLoadingState() : super._();
}

class SavedSearchDeleteSuccessState extends SavedSearchDeleteState {
  SavedSearchDeleteSuccessState() : super._();
}

class SavedSearchDeleteFailureState extends SavedSearchDeleteState {
  SavedSearchDeleteFailureState() : super._();
}

class SavedSearchDeleteNotInitializedState extends SavedSearchDeleteState {
  SavedSearchDeleteNotInitializedState() : super._();
}
