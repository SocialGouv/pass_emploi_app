import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

abstract class Reducer<T> {
  AppState reduce<T>(AppState currentState, Action<T> action) {
    if (action.isLoading()) {
      return stateToUpdate(currentState, State<T>.loading());
    } else if (action.isSuccess()) {
      return stateToUpdate(currentState, State<T>.success(action.getDataOrThrow()));
    } else if (action.isFailure()) {
      return stateToUpdate(currentState, State<T>.failure());
    } else if (action.isReset()) {
      return stateToUpdate(currentState, State<T>.notInitialized());
    } else {
      return currentState;
    }
  }

  AppState stateToUpdate<T>(AppState currentState, State<T> toUpdate);
}
