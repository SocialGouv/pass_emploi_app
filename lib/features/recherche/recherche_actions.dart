class RechercheRequestAction<Request> {
  final Request? request;

  RechercheRequestAction(this.request);
}

class RechercheSuccessAction<Result> {
  final List<Result> results;
  final bool canLoadMore;

  RechercheSuccessAction(this.results, this.canLoadMore);
}

class RechercheFailureAction {}

class RechercheResetAction {}
