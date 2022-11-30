import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_state.dart';

RendezvousDetailsState rendezvousDetailsReducer(RendezvousDetailsState current, dynamic action) {
  if (action is RendezvousDetailsLoadingAction) return RendezvousDetailsLoadingState();
  if (action is RendezvousDetailsFailureAction) return RendezvousDetailsFailureState();
  if (action is RendezvousDetailsSuccessAction) return RendezvousDetailsSuccessState(action.rendezvous);
  if (action is RendezvousDetailsResetAction) return RendezvousDetailsNotInitializedState();
  return current;
}
