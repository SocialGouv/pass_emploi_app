abstract class Action<T> {
  bool isLoading() => this is LoadingAction<T>;

  bool isSuccess() => this is SuccessAction<T>;

  bool isFailure() => this is FailureAction<T>;

  bool isReset() => this is ResetAction<T>;

  T getDataOrThrow() => (this as SuccessAction<T>).data;
}

class RequestAction<T> extends Action<T> {}

class LoadingAction<T> extends Action<T> {}

class SuccessAction<T> extends Action<T> {
  final T data;

  SuccessAction(this.data);
}

class FailureAction<T> extends Action<T> {}

class ResetAction<T> extends Action<T> {}
