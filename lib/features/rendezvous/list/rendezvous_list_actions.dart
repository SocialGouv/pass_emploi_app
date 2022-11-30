import 'package:pass_emploi_app/models/rendezvous.dart';

enum RendezvousPeriod { PASSE, FUTUR }

class RendezvousListRequestAction {
  final RendezvousPeriod period;

  RendezvousListRequestAction(this.period);
}

class RendezvousListLoadingAction {
  final RendezvousPeriod period;

  RendezvousListLoadingAction(this.period);
}

class RendezvousListSuccessAction {
  final List<Rendezvous> rendezvous;
  final RendezvousPeriod period;

  RendezvousListSuccessAction(this.rendezvous, this.period);
}

class RendezvousListFailureAction {
  final RendezvousPeriod period;

  RendezvousListFailureAction(this.period);
}

class RendezvousListResetAction {}
