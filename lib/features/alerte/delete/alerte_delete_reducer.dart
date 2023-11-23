import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_actions.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_state.dart';

AlerteDeleteState alerteDeleteReducer(AlerteDeleteState current, dynamic action) {
  if (action is AlerteDeleteLoadingAction) return AlerteDeleteLoadingState();
  if (action is AlerteDeleteFailureAction) return AlerteDeleteFailureState();
  if (action is AlerteDeleteSuccessAction) return AlerteDeleteSuccessState();
  if (action is AlerteDeleteResetAction) return AlerteDeleteNotInitializedState();
  return current;
}
