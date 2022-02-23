abstract class SavedSearchDeleteAction {}

class SavedSearchDeleteRequestAction extends SavedSearchDeleteAction {
  final String savedSearchId;

  SavedSearchDeleteRequestAction(this.savedSearchId);
}

class SavedSearchDeleteLoadingAction extends SavedSearchDeleteAction {}

class SavedSearchDeleteFailureAction extends SavedSearchDeleteAction {}

class SavedSearchDeleteSuccessAction extends SavedSearchDeleteAction {
  final String savedSearchId;

  SavedSearchDeleteSuccessAction(this.savedSearchId);
}

class SavedSearchDeleteResetAction extends SavedSearchDeleteAction {}
