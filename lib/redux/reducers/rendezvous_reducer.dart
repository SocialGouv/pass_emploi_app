import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/reducers/reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

class RendezvousReducer extends Reducer<List<Rendezvous>> {
  @override
  AppState stateToUpdate<T>(AppState currentState, State<T> toUpdate) {
    return currentState.copyWith(rendezvousState: toUpdate as State<List<Rendezvous>>);
  }
}
