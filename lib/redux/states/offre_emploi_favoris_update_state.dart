enum OffreEmploiFavorisUpdateStatus {
  LOADING, SUCCESS, ERROR
}

class OffreEmploiFavorisUpdateState {
  final Map<String, OffreEmploiFavorisUpdateStatus> requestStatus;

  OffreEmploiFavorisUpdateState(this.requestStatus);
}