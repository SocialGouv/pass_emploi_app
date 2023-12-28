import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_state.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
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
    case RendezvousStateSource.accueilProchainRendezvous:
      return _getRendezvousFromAccueilProchainRendezvousState(store, rdvId);
    case RendezvousStateSource.accueilProchaineSession:
      return _getRendezvousFromAccueilProchaineSessionState(store, rdvId);
    case RendezvousStateSource.accueilLesEvenements:
      return _getRendezvousFromAccueilLesEvenementsState(store, rdvId);
    case RendezvousStateSource.accueilLesEvenementsSession:
      return _getRendezvousFromAccueilSessionsMiloAVenirState(store, rdvId);
    case RendezvousStateSource.agenda:
      return _getRendezvousFromAgendaState(store, rdvId);
    case RendezvousStateSource.agendaSessionMilo:
      return _getRendezvousFromAgendaSessionState(store, rdvId);
    case RendezvousStateSource.rendezvousList:
      return _getRendezvousFromRendezvousListState(store, rdvId);
    case RendezvousStateSource.eventListAnimationsCollectives:
      return _getRendezvousFromEventListState(store, rdvId);
    case RendezvousStateSource.noSource:
      return _getRendezvousFromDetailsState(store);
    case RendezvousStateSource.eventListSessionsMilo:
      return _getRendezvousFromSessionMiloListState(store, rdvId);
    case RendezvousStateSource.sessionMiloDetails:
      return _getRendezvousFromSessionMiloDetailsState(store, rdvId);
    case RendezvousStateSource.rendezvousListSession:
      return _getRendezvousFromRendezvousListSessionState(store, rdvId);
  }
}

Rendezvous _getRendezvousFromEventListState(Store<AppState> store, String eventId) {
  final state = store.state.eventListState;
  if (state is! EventListSuccessState) throw Exception('Invalid state.');
  final Rendezvous? rendezvous = state.animationsCollectives.firstWhereOrNull((e) => e.id == eventId);
  if (rendezvous == null) throw Exception('No Rendezvous matching id $eventId');
  return rendezvous;
}

Rendezvous _getRendezvousFromSessionMiloListState(Store<AppState> store, String sessionId) {
  final state = store.state.eventListState;
  if (state is! EventListSuccessState) throw Exception('Invalid state.');
  final SessionMilo? sessionMilo = state.sessionsMilos.firstWhereOrNull((e) => e.id == sessionId);
  if (sessionMilo == null) throw Exception('No session matching id $sessionId');
  return sessionMilo.toRendezVous;
}

Rendezvous _getRendezvousFromSessionMiloDetailsState(Store<AppState> store, String sessionId) {
  final state = store.state.sessionMiloDetailsState;
  if (state is! SessionMiloDetailsSuccessState) throw Exception('Invalid state.');
  final sessionMilo = state.details;
  return sessionMilo.toRendezVous;
}

Rendezvous _getRendezvousFromRendezvousListState(Store<AppState> store, String rdvId) {
  final state = store.state.rendezvousListState;
  final rendezvous = state.rendezvous.where((e) => e.id == rdvId);
  if (rendezvous.isEmpty) throw Exception('No Rendezvous matching id $rdvId');
  return rendezvous.first;
}

Rendezvous _getRendezvousFromRendezvousListSessionState(Store<AppState> store, String rdvId) {
  final state = store.state.rendezvousListState;
  final session = state.sessionsMilo.where((e) => e.id == rdvId).firstOrNull;
  if (session == null) throw Exception('No session matching id $rdvId');
  return session.toRendezVous;
}

Rendezvous _getRendezvousFromAgendaState(Store<AppState> store, String rdvId) {
  final state = store.state.agendaState;
  if (state is! AgendaSuccessState) throw Exception('Invalid state.');
  final rendezvous = state.agenda.rendezvous.where((e) => e.id == rdvId).firstOrNull;
  if (rendezvous == null) throw Exception('No Rendezvous matching id $rdvId');
  return rendezvous;
}

Rendezvous _getRendezvousFromAgendaSessionState(Store<AppState> store, String rdvId) {
  final state = store.state.agendaState;
  if (state is! AgendaSuccessState) throw Exception('Invalid state.');
  final session = state.agenda.sessionsMilo.where((e) => e.id == rdvId).firstOrNull;
  if (session == null) throw Exception('No session matching id $rdvId');
  return session.toRendezVous;
}

Rendezvous _getRendezvousFromAccueilProchainRendezvousState(Store<AppState> store, String rdvId) {
  final state = store.state.accueilState;
  if (state is! AccueilSuccessState) throw Exception('Invalid state.');
  final rendezvous = state.accueil.prochainRendezVous;
  if (rendezvous == null) throw Exception('No prochain rendezvous');
  return rendezvous;
}

Rendezvous _getRendezvousFromAccueilProchaineSessionState(Store<AppState> store, String rdvId) {
  final state = store.state.accueilState;
  if (state is! AccueilSuccessState) throw Exception('Invalid state.');
  final session = state.accueil.prochaineSessionMilo;
  if (session == null) throw Exception('No prochaine session');
  return session.toRendezVous;
}

Rendezvous _getRendezvousFromAccueilLesEvenementsState(Store<AppState> store, String rdvId) {
  final state = store.state.accueilState;
  if (state is! AccueilSuccessState) throw Exception('Invalid state.');
  final rendezvous = state.accueil.animationsCollectives?.where((e) => e.id == rdvId).firstOrNull;
  if (rendezvous == null) throw Exception('No event');
  return rendezvous;
}

Rendezvous _getRendezvousFromAccueilSessionsMiloAVenirState(Store<AppState> store, String sessionId) {
  final state = store.state.accueilState;
  if (state is! AccueilSuccessState) throw Exception('Invalid state.');
  final session = state.accueil.sessionsMiloAVenir?.where((e) => e.id == sessionId).firstOrNull;
  if (session == null) throw Exception('No event');
  return session.toRendezVous;
}

Rendezvous _getRendezvousFromDetailsState(Store<AppState> store) {
  final state = store.state.rendezvousDetailsState;
  if (state is! RendezvousDetailsSuccessState) throw Exception('Invalid state.');
  return state.rendezvous;
}
