import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/models/demarche.dart';

AgendaState agendaReducer(AgendaState current, dynamic action) {
  if (action is AgendaRequestAction) return AgendaLoadingState();
  if (action is AgendaRequestReloadAction) return AgendaReloadingState();
  if (action is AgendaRequestFailureAction) return AgendaFailureState();
  if (action is AgendaRequestSuccessAction) return AgendaSuccessState(action.agenda);
  if (action is UpdateDemarcheSuccessAction) return _listWithUpdatedDemarches(current, action.modifiedDemarche);
  return current;
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
