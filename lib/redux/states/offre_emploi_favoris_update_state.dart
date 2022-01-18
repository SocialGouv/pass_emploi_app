enum FavorisUpdateStatus { LOADING, SUCCESS, ERROR }

class FavorisUpdateState {
  final Map<String, FavorisUpdateStatus> requestStatus;

  FavorisUpdateState(this.requestStatus);
}