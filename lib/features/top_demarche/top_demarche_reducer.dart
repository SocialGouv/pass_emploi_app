import 'package:pass_emploi_app/features/top_demarche/top_demarche_actions.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_state.dart';

TopDemarcheState topDemarcheReducer(TopDemarcheState current, dynamic action) {
  if (action is TopDemarcheSuccessAction) return TopDemarcheSuccessState(action.demarches);
  return current;
}
