import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';

AgendaState agendaReducer(AgendaState current, dynamic action) {
  if (action is AgendaRequestAction) return AgendaLoadingState();
  if (action is AgendaRequestFailureAction) return AgendaFailureState();
  if (action is AgendaRequestSuccessAction) return AgendaSuccessState(action.agenda);
  if (action is UserActionDeleteSuccessAction) return _listWithDeletedAction(current, action);
  if (action is UserActionUpdateNeededAction) return _listWithUpdatedAction(current, action);
  return current;
}

AgendaState _listWithDeletedAction(AgendaState current, UserActionDeleteSuccessAction action) {
  if (current is! AgendaSuccessState) return current;
  final newActions = current.agenda.actions.where((e) => e.id != action.actionId).toList();
  final newAgenda = current.agenda.copyWith(actions: newActions);
  return AgendaSuccessState(newAgenda);
}

AgendaState _listWithUpdatedAction(AgendaState current, UserActionUpdateNeededAction action) {
  if (current is! AgendaSuccessState) return current;
  final newActions = current.agenda.actions.withUpdatedAction(action.actionId, action.newStatus);
  final newAgenda = current.agenda.copyWith(actions: newActions);
  return AgendaSuccessState(newAgenda);
}
