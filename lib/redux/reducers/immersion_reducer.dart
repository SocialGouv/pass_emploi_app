import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/redux/reducers/reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

class ImmersionReducer extends Reducer<List<Immersion>> {
  @override
  AppState stateToUpdate<T>(AppState currentState, State<T> toUpdate) {
    return currentState.copyWith(immersionSearchState: toUpdate as State<List<Immersion>>);
  }
}
