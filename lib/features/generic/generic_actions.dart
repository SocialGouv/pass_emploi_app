sealed class Action<T> {}

class RequestAction<T> extends Action<T> {
  final bool forceRefresh;

  RequestAction({this.forceRefresh = false});
}

class LoadingAction<T> extends Action<T> {}

class SuccessAction<T> extends Action<T> {
  final T data;

  SuccessAction(this.data);
}

class FailureAction<T> extends Action<T> {}

class ResetAction<T> extends Action<T> {}
