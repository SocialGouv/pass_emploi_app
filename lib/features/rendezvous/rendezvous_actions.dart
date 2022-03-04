import 'package:pass_emploi_app/models/rendezvous.dart';

class RendezvousRequestAction {}

class RendezvousLoadingAction {}

class RendezvousSuccessAction {
  final List<Rendezvous> rendezvous;

  RendezvousSuccessAction(this.rendezvous);
}

class RendezvousFailureAction {}

class RendezvousResetAction {}
