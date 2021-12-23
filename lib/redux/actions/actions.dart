abstract class Action<REQUEST, RESULT> {
  Action._();

  factory Action.request(REQUEST request) = _RequestAction;

  factory Action.loading() = _LoadingAction;

  factory Action.success(RESULT result) = _SuccessAction;

  factory Action.failure() = _FailureAction;

  factory Action.reset() = _ResetAction;

  bool isRequest() => this is _RequestAction<REQUEST, RESULT>;

  bool isLoading() => this is _LoadingAction<REQUEST, RESULT>;

  bool isSuccess() => this is _SuccessAction<REQUEST, RESULT>;

  bool isFailure() => this is _FailureAction<REQUEST, RESULT>;

  bool isReset() => this is _ResetAction<REQUEST, RESULT>;

  REQUEST getRequestOrThrow() => (this as _RequestAction<REQUEST, RESULT>).request;

  RESULT getDataOrThrow() => (this as _SuccessAction<REQUEST, RESULT>).data;
}

class _RequestAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  final REQUEST request;

  _RequestAction(this.request) : super._();
}

class _LoadingAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  _LoadingAction() : super._();
}

class _SuccessAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  final RESULT data;

  _SuccessAction(this.data) : super._();
}

class _FailureAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  _FailureAction() : super._();
}

class _ResetAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  _ResetAction() : super._();
}
