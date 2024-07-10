import 'package:pass_emploi_app/features/matching_demarche/matching_demarche_actions.dart';
import 'package:pass_emploi_app/features/matching_demarche/matching_demarche_state.dart';

MatchingDemarcheState matchingDemarcheReducer(MatchingDemarcheState current, dynamic action) {
  if (action is MatchingDemarcheLoadingAction) return MatchingDemarcheLoadingState();
  if (action is MatchingDemarcheFailureAction) return MatchingDemarcheFailureState();
  if (action is MatchingDemarcheSuccessAction) return MatchingDemarcheSuccessState(action.result);
  if (action is MatchingDemarcheResetAction) return MatchingDemarcheNotInitializedState();
  return current;
}
