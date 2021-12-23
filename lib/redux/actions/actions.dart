abstract class Action<REQUEST, RESULT> {
  Action._();

  factory Action.request(REQUEST request) = RequestAction;

  factory Action.loading() = LoadingAction;

  factory Action.success(RESULT result) = SuccessAction;

  factory Action.failure() = FailureAction;

  factory Action.reset() = ResetAction;

  bool isRequest() => this is RequestAction<REQUEST, RESULT>;

  bool isLoading() => this is LoadingAction<REQUEST, RESULT>;

  bool isSuccess() => this is SuccessAction<REQUEST, RESULT>;

  bool isFailure() => this is FailureAction<REQUEST, RESULT>;

  bool isReset() => this is ResetAction<REQUEST, RESULT>;

  REQUEST getRequestOrThrow() => (this as RequestAction<REQUEST, RESULT>).request;

  RESULT getDataOrThrow() => (this as SuccessAction<REQUEST, RESULT>).data;
}

class RequestAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  final REQUEST request;

  RequestAction(this.request) : super._();
}

class LoadingAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  LoadingAction() : super._();
}

class SuccessAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  final RESULT data;

  SuccessAction(this.data) : super._();
}

class FailureAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  FailureAction() : super._();
}

class ResetAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  ResetAction() : super._();
}
