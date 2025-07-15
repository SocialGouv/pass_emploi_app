import 'package:pass_emploi_app/features/auto_inscription/auto_inscription_actions.dart';
import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_actions.dart';
import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';

ComptageDesHeuresState comptageDesHeuresReducer(ComptageDesHeuresState current, dynamic action) {
  if (action is ComptageDesHeuresFailureAction) return ComptageDesHeuresFailureState();
  if (action is ComptageDesHeuresSuccessAction) {
    return _comptageDesHeuresSuccess(current, action);
  }
  if (action is UserActionCreateSuccessAction) {
    return _incrementHeuresEnCoursDeCalcul(current);
  }
  if (action is AutoInscriptionSuccessAction) {
    return _incrementHeuresEnCoursDeCalcul(current);
  }
  return current;
}

ComptageDesHeuresState _incrementHeuresEnCoursDeCalcul(ComptageDesHeuresState current) {
  if (current is ComptageDesHeuresSuccessState) {
    return current.copyWith(heuresEnCoursDeCalcul: current.heuresEnCoursDeCalcul + 1);
  }
  return current;
}

ComptageDesHeuresState _comptageDesHeuresSuccess(
  ComptageDesHeuresState current,
  ComptageDesHeuresSuccessAction action,
) {
  if (current is ComptageDesHeuresSuccessState && current.comptageDesHeures == action.comptageDesHeures) {
    return current;
  }
  return ComptageDesHeuresSuccessState(comptageDesHeures: action.comptageDesHeures);
}
