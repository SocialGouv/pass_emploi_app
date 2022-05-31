import 'package:pass_emploi_app/features/campagne/campagne_actions.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';

CampagneState campagneReducer(CampagneState current, dynamic action) {
  if (action is CampagneFetchedAction) return CampagneState(action.campagne, current.answers);
  if (action is CampagneUpdateAnswersAction) return CampagneState(current.campagne, action.updatedAnswers);
  if (action is CampagneResetAction) return CampagneState(null, []);
  return current;
}
