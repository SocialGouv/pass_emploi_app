enum SendingState {
  none,
  loading,
  failure,
  alreadyDone,
  success;

  bool isNone() => this == SendingState.none;

  bool isLoading() => this == SendingState.loading;

  bool isFailure() => this == SendingState.failure;

  bool isAlreadyDone() => this == SendingState.alreadyDone;

  bool isSuccess() => this == SendingState.success;
}
