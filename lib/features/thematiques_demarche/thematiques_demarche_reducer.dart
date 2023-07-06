import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';

ThematiqueDemarcheState thematiquesDemarcheReducer(ThematiqueDemarcheState current, dynamic action) {
  if (action is ThematiqueDemarcheLoadingAction) return ThematiqueDemarcheLoadingState();
  if (action is ThematiqueDemarcheFailureAction) return ThematiqueDemarcheFailureState();
  if (action is ThematiqueDemarcheSuccessAction) return ThematiqueDemarcheSuccessState(action.thematiques);
  if (action is ThematiqueDemarcheResetAction) return ThematiqueDemarcheNotInitializedState();
  return current;
}
