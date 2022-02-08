enum SavedSearchUpdateStatus { LOADING, SUCCESS, ERROR }

class SavedSearchUpdateState {
  final Map<String, SavedSearchUpdateStatus> requestStatus;

  SavedSearchUpdateState(this.requestStatus);
}