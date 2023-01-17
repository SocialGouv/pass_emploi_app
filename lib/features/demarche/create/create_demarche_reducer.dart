import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';

CreateDemarcheState createDemarcheReducer(CreateDemarcheState current, dynamic action) {
  if (action is CreateDemarcheLoadingAction) return CreateDemarcheLoadingState();
  if (action is CreateDemarcheSuccessAction) return CreateDemarcheSuccessState(action.demarcheCreatedId);
  if (action is CreateDemarcheFailureAction) return CreateDemarcheFailureState();
  if (action is CreateDemarcheResetAction) return CreateDemarcheNotInitializedState();
  return current;
}
