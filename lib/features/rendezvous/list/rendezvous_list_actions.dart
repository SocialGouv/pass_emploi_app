import 'package:pass_emploi_app/models/rendezvous_list_result.dart';
import 'package:pass_emploi_app/models/session_milo.dart';

enum RendezvousPeriod { PASSE, FUTUR }

class RendezvousListRequestAction {
  final RendezvousPeriod period;

  RendezvousListRequestAction(this.period);
}

class RendezvousListLoadingAction {
  final RendezvousPeriod period;

  RendezvousListLoadingAction(this.period);
}

class RendezvousListRequestReloadAction {
  final RendezvousPeriod period;

  RendezvousListRequestReloadAction(this.period);
}

class RendezvousListReloadingAction {
  final RendezvousPeriod period;

  RendezvousListReloadingAction(this.period);
}

class RendezvousListSuccessAction {
  final RendezvousListResult rendezvousListResult;
  final List<SessionMilo> sessionsMilo;
  final RendezvousPeriod period;

  RendezvousListSuccessAction({required this.rendezvousListResult, required this.sessionsMilo, required this.period});
}

class RendezvousListFailureAction {
  final RendezvousPeriod period;

  RendezvousListFailureAction(this.period);
}

class RendezvousListResetAction {}
