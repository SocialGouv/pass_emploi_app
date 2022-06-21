enum DisplayState {
  CONTENT,
  LOADING,
  FAILURE,
  EMPTY;

  bool isLoading() => this == DisplayState.LOADING;

  bool isFailure() => this == DisplayState.FAILURE;
}
