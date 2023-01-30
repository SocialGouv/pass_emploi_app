import 'package:pass_emploi_app/features/raclette/raclette_actions.dart';
import 'package:pass_emploi_app/features/raclette/raclette_state.dart';

RacletteState racletteReducer(RacletteState current, dynamic action) {
  if (action is RacletteRequestAction) {
    return current.copyWith(
      status: RacletteStatus.loading,
      critere: () => action.critere,
    );
  } else if (action is RacletteSuccessAction) {
    return current.copyWith(
      status: RacletteStatus.success,
      result: () => action.result,
    );
  } else if (action is RacletteFailureAction) {
    return current.copyWith(
      status: RacletteStatus.failure,
    );
  }
  return current;
}
