import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_actions.dart';
import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_state.dart';

CampagneRecrutementState campagneRecrutementReducer(CampagneRecrutementState current, dynamic action) {
  if (action is CampagneRecrutementLoadingAction) return CampagneRecrutementLoadingState();
  if (action is CampagneRecrutementFailureAction) return CampagneRecrutementFailureState();
  if (action is CampagneRecrutementSuccessAction) return CampagneRecrutementSuccessState(action.result);
  if (action is CampagneRecrutementDismissAction) return CampagneRecrutementSuccessState(false);
  return current;
}
