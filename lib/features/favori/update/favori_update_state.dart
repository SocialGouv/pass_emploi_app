enum FavoriUpdateStatus { LOADING, SUCCESS, ERROR }

class FavoriUpdateState {
  final Map<String, FavoriUpdateStatus> requestStatus;

  FavoriUpdateState(this.requestStatus);
}