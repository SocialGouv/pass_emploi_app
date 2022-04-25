import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';

RendezvousState rendezvousReducer(RendezvousState current, dynamic action) {
  if (action is RendezvousLoadingAction) return current.copyWith(futurRendezVousStatus: RendezvousStatus.LOADING);
  if (action is RendezvousFailureAction) return current.copyWith(futurRendezVousStatus: RendezvousStatus.FAILURE);
  if (action is RendezvousSuccessAction) {
    return current.copyWith(futurRendezVousStatus: RendezvousStatus.SUCCESS, rendezvous: action.rendezvous);
  }
  if (action is RendezvousResetAction) return RendezvousState.notInitialized();
  return current;
}
