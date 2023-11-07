class NoRequest {}

sealed class Action<REQUEST, RESPONSE> {}

class RequestAction<REQUEST, RESPONSE> extends Action<REQUEST, RESPONSE> {
  final REQUEST request;
  final bool forceRefresh;

  RequestAction(this.request, {this.forceRefresh = false});
}

class LoadingAction<REQUEST, RESPONSE> extends Action<REQUEST, RESPONSE> {}

class SuccessAction<REQUEST, RESPONSE> extends Action<REQUEST, RESPONSE> {
  final RESPONSE data;

  SuccessAction(this.data);
}

class FailureAction<REQUEST, RESPONSE> extends Action<REQUEST, RESPONSE> {}

class ResetAction<REQUEST, RESPONSE> extends Action<REQUEST, RESPONSE> {}
