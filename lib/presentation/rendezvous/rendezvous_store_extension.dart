import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_state.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

extension RendezvousStoreExtension on Store<AppState> {
  Rendezvous getRendezvous(RendezvousStateSource source, String rdvId) {
    return switch (source) {
      RendezvousStateSource.accueilProchainRendezvous => _getRendezvousFromAccueilProchainRendezvousState(rdvId),
      RendezvousStateSource.accueilProchaineSession => _getRendezvousFromAccueilProchaineSessionState(rdvId),
      RendezvousStateSource.accueilLesEvenements => _getRendezvousFromAccueilLesEvenementsState(rdvId),
      RendezvousStateSource.accueilLesEvenementsSession => _getRendezvousFromAccueilSessionsMiloAVenirState(rdvId),
      RendezvousStateSource.monSuivi => _getRendezvousFromMonSuiviState(rdvId),
      RendezvousStateSource.monSuiviSessionMilo => _getRendezvousFromMonSuiviSessionState(rdvId),
      RendezvousStateSource.eventListAnimationsCollectives => _getRendezvousFromEventListState(rdvId),
      RendezvousStateSource.noSource => _getRendezvousFromDetailsState(),
      RendezvousStateSource.eventListSessionsMilo => _getRendezvousFromSessionMiloListState(rdvId),
      RendezvousStateSource.sessionMiloDetails => _getRendezvousFromSessionMiloDetailsState(rdvId),
    };
  }

  Rendezvous _getRendezvousFromEventListState(String eventId) {
    final state = this.state.eventListState;
    if (state is! EventListSuccessState) throw Exception('Invalid state.');
    final Rendezvous? rendezvous = state.animationsCollectives.firstWhereOrNull((e) => e.id == eventId);
    if (rendezvous == null) throw Exception('No Rendezvous matching id $eventId');
    return rendezvous;
  }

  Rendezvous _getRendezvousFromSessionMiloListState(String sessionId) {
    final state = this.state.eventListState;
    if (state is! EventListSuccessState) throw Exception('Invalid state.');
    final SessionMilo? sessionMilo = state.sessionsMilos.firstWhereOrNull((e) => e.id == sessionId);
    if (sessionMilo == null) throw Exception('No session matching id $sessionId');
    return sessionMilo.toRendezVous;
  }

  Rendezvous _getRendezvousFromSessionMiloDetailsState(String sessionId) {
    final state = this.state.sessionMiloDetailsState;
    if (state is! SessionMiloDetailsSuccessState) throw Exception('Invalid state.');
    final sessionMilo = state.details;
    return sessionMilo.toRendezVous;
  }

  Rendezvous _getRendezvousFromMonSuiviState(String rdvId) {
    final state = this.state.monSuiviState;
    if (state is! MonSuiviSuccessState) throw Exception('Invalid state.');
    final rendezvous = state.monSuivi.rendezvous.where((e) => e.id == rdvId).firstOrNull;
    if (rendezvous == null) throw Exception('No Rendezvous matching id $rdvId');
    return rendezvous;
  }

  Rendezvous _getRendezvousFromMonSuiviSessionState(String rdvId) {
    final state = this.state.monSuiviState;
    if (state is! MonSuiviSuccessState) throw Exception('Invalid state.');
    final session = state.monSuivi.sessionsMilo.where((e) => e.id == rdvId).firstOrNull;
    if (session == null) throw Exception('No session matching id $rdvId');
    return session.toRendezVous;
  }

  Rendezvous _getRendezvousFromAccueilProchainRendezvousState(String rdvId) {
    final state = this.state.accueilState;
    if (state is! AccueilSuccessState) throw Exception('Invalid state.');
    final rendezvous = state.accueil.prochainRendezVous;
    if (rendezvous == null) throw Exception('No prochain rendezvous');
    return rendezvous;
  }

  Rendezvous _getRendezvousFromAccueilProchaineSessionState(String rdvId) {
    final state = this.state.accueilState;
    if (state is! AccueilSuccessState) throw Exception('Invalid state.');
    final session = state.accueil.prochaineSessionMilo;
    if (session == null) throw Exception('No prochaine session');
    return session.toRendezVous;
  }

  Rendezvous _getRendezvousFromAccueilLesEvenementsState(String rdvId) {
    final state = this.state.accueilState;
    if (state is! AccueilSuccessState) throw Exception('Invalid state.');
    final rendezvous = state.accueil.animationsCollectives?.where((e) => e.id == rdvId).firstOrNull;
    if (rendezvous == null) throw Exception('No event');
    return rendezvous;
  }

  Rendezvous _getRendezvousFromAccueilSessionsMiloAVenirState(String sessionId) {
    final state = this.state.accueilState;
    if (state is! AccueilSuccessState) throw Exception('Invalid state.');
    final session = state.accueil.sessionsMiloAVenir?.where((e) => e.id == sessionId).firstOrNull;
    if (session == null) throw Exception('No event');
    return session.toRendezVous;
  }

  Rendezvous _getRendezvousFromDetailsState() {
    final state = this.state.rendezvousDetailsState;
    if (state is! RendezvousDetailsSuccessState) throw Exception('Invalid state.');
    return state.rendezvous;
  }
}
