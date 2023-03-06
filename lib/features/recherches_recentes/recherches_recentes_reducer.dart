import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_actions.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_state.dart';

RecherchesRecentesState recherchesRecentesReducer(RecherchesRecentesState current, dynamic action) {
  if (action is RecherchesRecentesLoadingAction) return RecherchesRecentesLoadingState();
  if (action is RecherchesRecentesSuccessAction) return RecherchesRecentesSuccessState(action.recentSearches);
  if (action is RecherchesRecentesResetAction) return RecherchesRecentesNotInitializedState();
  return current;
}
