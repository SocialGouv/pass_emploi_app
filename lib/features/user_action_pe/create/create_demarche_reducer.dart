import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_state.dart';

CreateDemarcheState createDemarcheReducer(CreateDemarcheState current, dynamic action) {
  if (action is CreateDemarcheLoadingAction) return CreateDemarcheLoadingState();
  if (action is CreateDemarcheSuccessAction) return CreateDemarcheSuccessState();
  if (action is CreateDemarcheFailureAction) return CreateDemarcheFailureState();
  if (action is CreateDemarcheResetAction) return CreateDemarcheNotInitializedState();
  return current;
}
