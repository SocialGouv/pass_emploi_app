import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

String takeTypeLabelOrPrecision(Rendezvous rdv) {
  return (rdv.type.code == RendezvousTypeCode.AUTRE && rdv.precision != null) ? rdv.precision! : rdv.type.label;
}

bool isRendezvousGreenTag(Rendezvous rdv) {
  final tag = takeTypeLabelOrPrecision(rdv);
  return tag == Strings.individualInterview || tag == Strings.publicInfo;
}

Rendezvous getRendezvous(Store<AppState> store, RendezvousStateSource source, String rdvId) {
  switch (source) {
    case RendezvousStateSource.agenda:
      return _getRendezvousFromAgendaState(store, rdvId);
    case RendezvousStateSource.rendezvousList:
      return _getRendezvousFromRendezvousListState(store, rdvId);
    case RendezvousStateSource.eventList:
      return _getRendezvousFromEventListState(store, rdvId);
    case RendezvousStateSource.noSource:
      return _getRendezvousFromDetailsState(store);
  }
}

Rendezvous _getRendezvousFromEventListState(Store<AppState> store, String rdvId) {
  final state = store.state.eventListState;
  if (state is! EventListSuccessState) throw Exception('Invalid state.');
  final rendezvous = state.events.where((e) => e.id == rdvId);
  if (rendezvous.isEmpty) throw Exception('No Rendezvous matching id $rdvId');
  return rendezvous.first;
}

Rendezvous _getRendezvousFromRendezvousListState(Store<AppState> store, String rdvId) {
  final state = store.state.rendezvousListState;
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

Rendezvous _getRendezvousFromDetailsState(Store<AppState> store) {
  final state = store.state.rendezvousDetailsState;
  if (state is! RendezvousDetailsSuccessState) throw Exception('Invalid state.');
  return state.rendezvous;
}
