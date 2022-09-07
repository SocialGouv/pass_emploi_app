import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

String takeTypeLabelOrPrecision(Rendezvous rdv) {
  return (rdv.type.code == RendezvousTypeCode.AUTRE && rdv.precision != null) ? rdv.precision! : rdv.type.label;
}

Rendezvous getRendezvous(Store<AppState> store, RendezvousStateSource source, String rdvId) {
  switch (source) {
    case RendezvousStateSource.agenda:
      return _getRendezvousFromAgendaState(store, rdvId);
    case RendezvousStateSource.list:
      return _getRendezvousFromRendezvousState(store, rdvId);
  }
}

Rendezvous _getRendezvousFromRendezvousState(Store<AppState> store, String rdvId) {
  final state = store.state.rendezvousState;
  final rendezvous = state.rendezvous.where((e) => e.id == rdvId);
  if (rendezvous.isEmpty) throw Exception('No Rendezvous matching id $rdvId');
  return rendezvous.first;
}

Rendezvous _getRendezvousFromAgendaState(Store<AppState> store, String rdvId) {
  final state = store.state.agendaState;
  if (state is! AgendaSuccessState) throw Exception('Invalid state.');
  final rendezvous = state.agenda.rendezvous.where((e) => e.id == rdvId).firstOrNull;
  if (rendezvous == null) throw Exception('No Rendezvous matching id $rdvId');
  return rendezvous;
}
