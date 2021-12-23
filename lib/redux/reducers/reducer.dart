import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

class Reducer<T> {
  State<T> reduce<T>(State<T> currentState, Action<T> action) {
    if (action.isLoading()) return State<T>.loading();
    if (action.isSuccess()) return State<T>.success(action.getDataOrThrow());
    if (action.isFailure()) return State<T>.failure();
    if (action.isReset()) return State<T>.notInitialized();
    return currentState;
  }
}
