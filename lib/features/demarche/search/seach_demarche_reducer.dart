import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';

SearchDemarcheState searchDemarcheReducer(SearchDemarcheState current, dynamic action) {
  if (action is SearchDemarcheLoadingAction) return SearchDemarcheLoadingState();
  if (action is SearchDemarcheFailureAction) return SearchDemarcheFailureState();
  if (action is SearchDemarcheSuccessAction) return SearchDemarcheSuccessState(action.demarchesDuReferentiel);
  if (action is SearchDemarcheResetAction) return SearchDemarcheNotInitializedState();
  return current;
}
