import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

AppState rendezvousReducer(AppState currentState, Action<List<Rendezvous>> action) {
  if (action.isLoading()) {
    return currentState.copyWith(rendezvousState: State<List<Rendezvous>>.loading());
  } else if (action.isSuccess()) {
    return currentState.copyWith(rendezvousState: State<List<Rendezvous>>.success(action.getDataOrThrow()));
  } else if (action.isFailure()) {
    return currentState.copyWith(rendezvousState: State<List<Rendezvous>>.failure());
  } else {
    return currentState;
  }
}
