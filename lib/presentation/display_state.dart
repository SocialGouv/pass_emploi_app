import 'package:pass_emploi_app/redux/states/state.dart';

enum DisplayState { CONTENT, LOADING, FAILURE, EMPTY }

DisplayState displayStateFromState<T>(State<T> state) {
  if (state.isLoading()) return DisplayState.LOADING;
  if (state.isSuccess()) return DisplayState.CONTENT;
  return DisplayState.FAILURE;
}
