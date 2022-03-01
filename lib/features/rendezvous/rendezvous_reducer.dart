import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';

RendezvousState rendezvousReducer(RendezvousState current, dynamic action) {
  if (action is RendezvousLoadingAction) return RendezvousLoadingState();
  if (action is RendezvousFailureAction) return RendezvousFailureState();
  if (action is RendezvousSuccessAction) return RendezvousSuccessState(action.rendezvous);
  if (action is RendezvousResetAction) return RendezvousNotInitializedState();
  return current;
}
