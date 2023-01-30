import 'package:pass_emploi_app/features/raclette/raclette_actions.dart';
import 'package:pass_emploi_app/features/raclette/raclette_state.dart';

RacletteState racletteReducer(RacletteState current, dynamic action) {
  if (action is RacletteRequestAction) {
    current.copyWith(status: RacletteStatus.loading, critere: () => action.critere,);
  }
  if (action is RacletteLoadingAction) return RacletteLoadingState();
  if (action is RacletteFailureAction) return RacletteFailureState();
  if (action is RacletteSuccessAction) return RacletteSuccessState(action.result);
  if (action is RacletteResetAction) return RacletteNotInitializedState();
  return current;
}}
