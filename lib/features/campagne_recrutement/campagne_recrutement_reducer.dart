import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_actions.dart';
import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_state.dart';

CampagneRecrutementState campagneRecrutementReducer(CampagneRecrutementState current, dynamic action) {
  if (action is CampagneRecrutementResultAction) return CampagneRecrutementResultState(action.withCampagne);
  if (action is CampagneRecrutementDismissAction) return CampagneRecrutementResultState(false);
  return current;
}
