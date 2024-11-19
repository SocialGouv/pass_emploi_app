import 'package:pass_emploi_app/features/derniere_offre_consultee/derniere_offre_consultee_actions.dart';
import 'package:pass_emploi_app/features/derniere_offre_consultee/derniere_offre_consultee_state.dart';

DerniereOffreConsulteeState derniereOffreConsulteeReducer(DerniereOffreConsulteeState current, dynamic action) {
  if (action is DerniereOffreConsulteeUpdateAction) return DerniereOffreConsulteeState(offre: action.offre);
  return current;
}
