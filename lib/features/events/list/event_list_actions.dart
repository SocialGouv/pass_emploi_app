import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';

class EventListRequestAction {
  final DateTime maintenant;

  EventListRequestAction(this.maintenant);
}

class EventListLoadingAction {}

class EventListSuccessAction {
  final List<Rendezvous> events;
  final List<SessionMilo> sessionsMilos;

  EventListSuccessAction(this.events, this.sessionsMilos);
}

class EventListFailureAction {}
