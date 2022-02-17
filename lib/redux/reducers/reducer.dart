import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

class Reducer<RESULT> {
  State<RESULT> reduce(State<RESULT> currentState, Action<dynamic, RESULT> action) {
    if (action.isLoading()) return State<RESULT>.loading();
    if (action.isSuccess()) return State<RESULT>.success(action.getResultOrThrow());
    if (action.isFailure()) return State<RESULT>.failure();
    if (action.isReset()) return State<RESULT>.notInitialized();
    return currentState;
  }
}
