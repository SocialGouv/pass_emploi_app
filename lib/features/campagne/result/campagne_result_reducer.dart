import 'package:pass_emploi_app/features/campagne/result/campagne_result_actions.dart';
import 'package:pass_emploi_app/features/campagne/result/campagne_result_state.dart';

CampagneResultState campagneResultReducer(CampagneResultState current, dynamic action) {
  if (action is CampagneUpdateAnswersAction) return CampagneResultState(action.updatedAnswers);
  if (action is CampagneResetAction) return CampagneResultState([]);
  return current;
}
