import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_actions.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_actions.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_state.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';

AlerteListState alerteListReducer(AlerteListState current, dynamic action) {
  if (action is AlerteListLoadingAction) return AlerteListLoadingState();
  if (action is AlerteListFailureAction) return AlerteListFailureState();
  if (action is AlerteListSuccessAction) return AlerteListSuccessState(action.alertes);
  if (action is AlerteListResetAction) return AlerteListNotInitializedState();
  if (action is AlerteDeleteSuccessAction && current is AlerteListSuccessState) {
    final List<Alerte> alertes = current.alertes;
    alertes.removeWhere((element) => element.getId() == action.alerteId);
    return AlerteListSuccessState(alertes);
  }
  return current;
}
