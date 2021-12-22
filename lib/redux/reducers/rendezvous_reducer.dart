import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/actions/rendezvous_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

AppState rendezvousReducer(AppState currentState, RendezvousAction action) {
  if (action is RendezvousLoadingAction) {
    return currentState.copyWith(rendezvousState: State<List<Rendezvous>>.loading());
  } else if (action is RendezvousSuccessAction) {
    return currentState.copyWith(rendezvousState: State<List<Rendezvous>>.success(action.rendezvous));
  } else if (action is RendezvousFailureAction) {
    return currentState.copyWith(rendezvousState: State<List<Rendezvous>>.failure());
  } else {
    return currentState;
  }
}
