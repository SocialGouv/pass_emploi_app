import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/user_action.dart';

AgendaState agendaReducer(AgendaState current, dynamic action) {
  if (action is AgendaRequestAction) return AgendaLoadingState();
  if (action is AgendaRequestReloadAction) return AgendaReloadingState();
  if (action is AgendaRequestFailureAction) return AgendaFailureState();
  if (action is AgendaRequestSuccessAction) return AgendaSuccessState(action.agenda);
  if (action is UserActionDeleteSuccessAction) return _listWithDeletedAction(current, action);
  if (action is UserActionUpdateSuccessAction) return _listWithUpdatedAction(current, action);
  if (action is UpdateDemarcheSuccessAction) return _listWithUpdatedDemarches(current, action.modifiedDemarche);
  return current;
}

AgendaState _listWithDeletedAction(AgendaState current, UserActionDeleteSuccessAction action) {
  if (current is! AgendaSuccessState) return current;
  final newActions = current.agenda.actions.where((e) => e.id != action.actionId).toList();
  final newAgenda = current.agenda.copyWith(actions: newActions);
  return AgendaSuccessState(newAgenda);
}

AgendaState _listWithUpdatedAction(AgendaState current, UserActionUpdateSuccessAction action) {
  if (current is! AgendaSuccessState) return current;
  final newActions = current.agenda.actions.withUpdatedAction(action.actionId, action.request);
  final newAgenda = current.agenda.copyWith(actions: newActions);
  return AgendaSuccessState(newAgenda);
}

AgendaState _listWithUpdatedDemarches(AgendaState current, Demarche modifiedDemarche) {
  if (current is! AgendaSuccessState) return current;
  final currentDemarches = current.agenda.demarches.toList();
  final indexOfCurrentDemarche = currentDemarches.indexWhere((e) => e.id == modifiedDemarche.id);
  if (indexOfCurrentDemarche == -1) return current;
  currentDemarches[indexOfCurrentDemarche] = modifiedDemarche;
  final newAgenda = current.agenda.copyWith(demarches: currentDemarches);
  return AgendaSuccessState(newAgenda);
}
