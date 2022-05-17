import 'package:pass_emploi_app/models/rendezvous.dart';

enum RendezvousPeriod { PASSE, FUTUR }

class RendezvousRequestAction {
  final RendezvousPeriod period;

  RendezvousRequestAction(this.period);
}

class RendezvousLoadingAction {
  final RendezvousPeriod period;

  RendezvousLoadingAction(this.period);
}

class RendezvousSuccessAction {
  final List<Rendezvous> rendezvous;
  final RendezvousPeriod period;

  RendezvousSuccessAction(this.rendezvous, this.period);
}

class RendezvousFailureAction {
  final RendezvousPeriod period;

  RendezvousFailureAction(this.period);
}

class RendezvousResetAction {}
