abstract class Action<REQUEST, RESULT> {
  bool isLoading() => this is LoadingAction<REQUEST, RESULT>;

  bool isSuccess() => this is SuccessAction<REQUEST, RESULT>;

  bool isFailure() => this is FailureAction<REQUEST, RESULT>;

  bool isReset() => this is ResetAction<REQUEST, RESULT>;

  RESULT getDataOrThrow() => (this as SuccessAction<REQUEST, RESULT>).data;
}

class RequestAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  final REQUEST request;

  RequestAction(this.request);
}

class LoadingAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {}

class SuccessAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {
  final RESULT data;

  SuccessAction(this.data);
}

class FailureAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {}

class ResetAction<REQUEST, RESULT> extends Action<REQUEST, RESULT> {}
