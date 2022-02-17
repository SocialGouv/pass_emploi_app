import 'package:pass_emploi_app/redux/actions/search_metier_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

import '../states/search_metier_state.dart';

AppState searchMetierReducer(AppState currentState, SearchMetierAction action) {
  if (action is SearchMetierSuccessAction) {
    return currentState.copyWith(searchMetierState: SearchMetierState(action.metiers));
  } else if (action is ResetMetierAction) {
    return currentState.copyWith(searchMetierState: SearchMetierState([]));
  } else {
    return currentState;
  }
}
