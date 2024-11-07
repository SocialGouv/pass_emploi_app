import 'package:pass_emploi_app/features/date_consultation_offre/date_consultation_offre_actions.dart';
import 'package:pass_emploi_app/features/date_consultation_offre/date_consultation_offre_state.dart';

DateConsultationOffreState dateConsultationOffreReducer(DateConsultationOffreState current, dynamic action) {
  if (action is DateConsultationUpdateAction) {
    return DateConsultationOffreState(Map<String, DateTime>.from(action.offreIdToDateConsultation));
  }
  return current;
}
