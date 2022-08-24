import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarhce_state.dart';

UpdateDemarcheState updateDemarcheReducer(UpdateDemarcheState current, dynamic action) {
  if (action is UpdateDemarcheLoadingAction) return UpdateDemarcheLoadingState();
  if (action is UpdateDemarcheSuccessAction) return UpdateDemarcheSuccessState();
  if (action is UpdateDemarcheFailureAction) return UpdateDemarcheFailureState();
  if (action is UpdateDemarcheResetAction) return UpdateDemarcheNotInitializedState();
  return current;
}
