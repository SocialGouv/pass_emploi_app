enum SendingState {
  none,
  loading,
  failure,
  success;

  bool isNone() => this == SendingState.none;

  bool isLoading() => this == SendingState.loading;

  bool isFailure() => this == SendingState.failure;

  bool isSuccess() => this == SendingState.success;
}
