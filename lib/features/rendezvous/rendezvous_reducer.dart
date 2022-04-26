import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';

RendezvousState rendezvousReducer(RendezvousState current, dynamic action) {
  if (action is RendezvousLoadingAction) {
    if (action.period == RendezvousPeriod.FUTUR) {
      return current.copyWith(futurRendezVousStatus: RendezvousStatus.LOADING);
    } else {
      return current.copyWith(pastRendezVousStatus: RendezvousStatus.LOADING);
    }
  }
  if (action is RendezvousFailureAction) {
    if (action.period == RendezvousPeriod.FUTUR) {
      return current.copyWith(futurRendezVousStatus: RendezvousStatus.FAILURE);
    } else {
      return current.copyWith(pastRendezVousStatus: RendezvousStatus.FAILURE);
    }
  }
  if (action is RendezvousSuccessAction) {
    if (action.period == RendezvousPeriod.FUTUR) {
      return current.copyWith(futurRendezVousStatus: RendezvousStatus.SUCCESS, rendezvous: action.rendezvous);
    } else {
      final rendezvous = action.rendezvous + current.rendezvous;
      return current.copyWith(pastRendezVousStatus: RendezvousStatus.SUCCESS, rendezvous: rendezvous);
    }
  }
  if (action is RendezvousResetAction) return RendezvousState.notInitialized();
  return current;
}
