import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/features/metier/search_metier_state.dart';

SearchMetierState searchMetierReducer(SearchMetierState currentState, dynamic action) {
  if (action is SearchMetierSuccessAction) return SearchMetierState(action.metiers);
  if (action is SearchMetierResetAction) return SearchMetierState([]);
  return currentState;
}
