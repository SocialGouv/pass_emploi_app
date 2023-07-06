import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';

ThematiquesDemarcheState thematiquesDemarcheReducer(ThematiquesDemarcheState current, dynamic action) {
  if (action is ThematiquesDemarcheLoadingAction) return ThematiquesDemarcheLoadingState();
  if (action is ThematiquesDemarcheFailureAction) return ThematiquesDemarcheFailureState();
  if (action is ThematiquesDemarcheSuccessAction) return ThematiquesDemarcheSuccessState(action.thematiques);
  if (action is ThematiquesDemarcheResetAction) return ThematiquesDemarcheNotInitializedState();
  return current;
}
