import 'package:pass_emploi_app/models/rendezvous.dart';

class EventListRequestAction {}

class EventListLoadingAction {}

class EventListSuccessAction {
  final List<Rendezvous> events;

  EventListSuccessAction(this.events);
}

class EventListFailureAction {}
