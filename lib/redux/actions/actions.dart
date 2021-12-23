abstract class Action<REQUEST, RESULT> {
  static Action<REQUEST, RESULT> loading<REQUEST, RESULT>() => LoadingAction<REQUEST, RESULT>();

  static Action<REQUEST, RESULT> failure<REQUEST, RESULT>() => FailureAction<REQUEST, RESULT>();

  static Action<REQUEST, RESULT> reset<REQUEST, RESULT>() => ResetAction<REQUEST, RESULT>();

  static Action<REQUEST, RESULT> request<REQUEST, RESULT>(REQUEST request) => RequestAction<REQUEST, RESULT>(request);

  static Action<REQUEST, RESULT> success<REQUEST, RESULT>(RESULT result) => SuccessAction<REQUEST, RESULT>(result);

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
