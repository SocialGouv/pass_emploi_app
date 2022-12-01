import 'package:pass_emploi_app/models/rendezvous.dart';

class RendezvousDetailsRequestAction {
  final String rendezvousId;

  RendezvousDetailsRequestAction(this.rendezvousId);
}

class RendezvousDetailsLoadingAction {}

class RendezvousDetailsSuccessAction {
  final Rendezvous rendezvous;

  RendezvousDetailsSuccessAction(this.rendezvous);
}

class RendezvousDetailsFailureAction {}

class RendezvousDetailsResetAction {}
