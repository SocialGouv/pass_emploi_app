import 'package:pass_emploi_app/features/suggestions_recherche/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/suggestions_recherche_state.dart';

SuggestionsRechercheState suggestionsRechercheReducer(SuggestionsRechercheState current, dynamic action) {
  if (action is SuggestionsRechercheLoadingAction) return SuggestionsRechercheLoadingState();
  if (action is SuggestionsRechercheSuccessAction) return SuggestionsRechercheSuccessState(action.suggestions);
  if (action is SuggestionsRechercheFailureAction) return SuggestionsRechercheFailureState();
  return current;
}
