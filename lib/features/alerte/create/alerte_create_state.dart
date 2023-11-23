enum AlerteCreateStatus { NOT_SENT, LOADING, SUCCESS, ERROR }

abstract class AlerteCreateState<T> {
  AlerteCreateState();

  abstract AlerteCreateStatus status;

  factory AlerteCreateState.notInitialized() = AlerteCreateNotInitialized;

  factory AlerteCreateState.initialized(T search) = AlerteCreateInitialized;

  factory AlerteCreateState.successfullyCreated() = AlerteCreateSuccessfullyCreated;

  factory AlerteCreateState.loading() = AlerteCreateLoadingState;

  factory AlerteCreateState.failure() = AlerteCreateFailureState;
}

class AlerteCreateNotInitialized<T> extends AlerteCreateState<T> {
  @override
  AlerteCreateStatus status = AlerteCreateStatus.NOT_SENT;
}

class AlerteCreateInitialized<T> extends AlerteCreateState<T> {
  @override
  AlerteCreateStatus status = AlerteCreateStatus.NOT_SENT;
  T search;

  AlerteCreateInitialized(this.search);
}

class AlerteCreateSuccessfullyCreated<T> extends AlerteCreateState<T> {
  @override
  AlerteCreateStatus status = AlerteCreateStatus.SUCCESS;
}

class AlerteCreateFailureState<T> extends AlerteCreateState<T> {
  @override
  AlerteCreateStatus status = AlerteCreateStatus.ERROR;
}

class AlerteCreateLoadingState<T> extends AlerteCreateState<T> {
  @override
  AlerteCreateStatus status = AlerteCreateStatus.LOADING;
}
