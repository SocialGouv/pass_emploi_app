import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_actions.dart';
import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_state.dart';

CampagneRecrutementState campagneRecrutementReducer(CampagneRecrutementState current, dynamic action) {
  if (action is CampagneRecrutementSuccessAction) return CampagneRecrutementSuccessState(action.withCampagne);
  if (action is CampagneRecrutementDismissAction) return CampagneRecrutementSuccessState(false);
  return current;
}
