class SavedSearchDeleteRequestAction {
  final String savedSearchId;

  SavedSearchDeleteRequestAction(this.savedSearchId);
}

class SavedSearchDeleteLoadingAction {}

class SavedSearchDeleteSuccessAction {
  final String savedSearchId;

  SavedSearchDeleteSuccessAction(this.savedSearchId);
}

class SavedSearchDeleteFailureAction {}

class SavedSearchDeleteResetAction {}
