import 'package:pass_emploi_app/features/campagne/campagne_result_actions.dart';
import 'package:pass_emploi_app/features/campagne/campagne_result_state.dart';

CampagneResultState campagneResultReducer(CampagneResultState current, dynamic action) {
  if (action is CampagneUpdateAnswersAction) return CampagneResultState(action.updatedAnswers);
  return current;
}
