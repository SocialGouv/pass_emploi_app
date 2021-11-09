import 'package:pass_emploi_app/redux/actions/rendezvous_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/rendezvous_state.dart';

AppState rendezvousReducer(AppState currentState, RendezvousAction action) {
  if (action is RendezvousLoadingAction) {
    return currentState.copyWith(rendezvousState: RendezvousState.loading());
  } else if (action is RendezvousSuccessAction) {
    return currentState.copyWith(rendezvousState: RendezvousState.success(action.rendezvous));
  } else if (action is RendezvousFailureAction) {
    return currentState.copyWith(rendezvousState: RendezvousState.failure());
  } else {
    return currentState;
  }
}
