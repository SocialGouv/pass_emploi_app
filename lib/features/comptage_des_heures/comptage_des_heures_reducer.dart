import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_actions.dart';
import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_state.dart';

ComptageDesHeuresState comptageDesHeuresReducer(ComptageDesHeuresState current, dynamic action) {
  if (action is ComptageDesHeuresLoadingAction) return ComptageDesHeuresLoadingState();
  if (action is ComptageDesHeuresFailureAction) return ComptageDesHeuresFailureState();
  if (action is ComptageDesHeuresSuccessAction) return ComptageDesHeuresSuccessState(action.comptageDesHeures);
  return current;
}
