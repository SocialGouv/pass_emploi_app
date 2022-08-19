import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';

AgendaState agendaReducer(AgendaState current, dynamic action) {
  if (action is AgendaRequestAction) return AgendaStateLoading();
  if (action is AgendaRequestSuccessAction) return AgendaStateSuccess(action.agenda);
  return current;
}
