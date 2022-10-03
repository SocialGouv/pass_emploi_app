import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';

SuggestionsRechercheState suggestionsRechercheReducer(SuggestionsRechercheState current, dynamic action) {
  if (action is SuggestionsRechercheLoadingAction) return SuggestionsRechercheLoadingState();
  if (action is SuggestionsRechercheSuccessAction) return SuggestionsRechercheSuccessState(action.suggestions);
  if (action is SuggestionsRechercheFailureAction) return SuggestionsRechercheFailureState();
  if (action is AccepterSuggestionRechercheSuccessAction) {
    if (current is! SuggestionsRechercheSuccessState) return current;
    final suggestion = current.suggestions;
    suggestion.removeWhere((element) => element.id == action.suggestion.id);
    return SuggestionsRechercheSuccessState(suggestion);
  }
  return current;
}
