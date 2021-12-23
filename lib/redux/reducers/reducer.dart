import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

class Reducer<REQUEST, RESULT> {
  State<RESULT> reduce<RESULT>(State<RESULT> currentState, Action<REQUEST, RESULT> action) {
    if (action.isLoading()) return State<RESULT>.loading();
    if (action.isSuccess()) return State<RESULT>.success(action.getDataOrThrow());
    if (action.isFailure()) return State<RESULT>.failure();
    if (action.isReset()) return State<RESULT>.notInitialized();
    return currentState;
  }
}
