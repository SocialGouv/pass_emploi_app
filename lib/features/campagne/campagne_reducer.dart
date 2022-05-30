import 'package:pass_emploi_app/features/campagne/campagne_actions.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';

CampagneState campagneReducer(CampagneState current, dynamic action) {
  if (action is UserActionListSuccessAction) return CampagneState(action.campagne, current.answers);
  if (action is UserActionPEListSuccessAction) return CampagneState(action.campagne, current.answers);
  if (action is CampagneUpdateAnswersAction) return CampagneState(current.campagne, action.updatedAnswers);
  if (action is CampagneResetAction) return CampagneState(null, []);
  return current;
}
