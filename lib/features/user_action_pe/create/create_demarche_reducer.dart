import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_state.dart';

CreateDemarcheState createDemarcheReducer(CreateDemarcheState current, dynamic action) {
  if (action is CreateDemarcheFailureAction) {
    return CreateDemarcheFailureState();
  }
  if (action is CreateDemarcheSuccessAction) {
    return CreateDemarcheSuccessState();
  }
  return current;
}
