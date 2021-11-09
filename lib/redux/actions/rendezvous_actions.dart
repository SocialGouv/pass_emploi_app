import 'package:pass_emploi_app/models/rendezvous.dart';

abstract class RendezvousAction {}

class RendezvousLoadingAction extends RendezvousAction {}

class RendezvousSuccessAction extends RendezvousAction {
  final List<Rendezvous> rendezvous;

  RendezvousSuccessAction(this.rendezvous);
}

class RendezvousFailureAction extends RendezvousAction {}
