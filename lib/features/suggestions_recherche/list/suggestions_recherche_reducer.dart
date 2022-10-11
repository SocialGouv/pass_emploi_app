import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';

SuggestionsRechercheState suggestionsRechercheReducer(SuggestionsRechercheState current, dynamic action) {
  if (action is SuggestionsRechercheLoadingAction) return SuggestionsRechercheLoadingState();
  if (action is SuggestionsRechercheSuccessAction) return SuggestionsRechercheSuccessState(action.suggestions);
  if (action is SuggestionsRechercheFailureAction) return SuggestionsRechercheFailureState();
  if (action is AccepterSuggestionRechercheSuccessAction) return _removingSuggestion(current, action.suggestionId);
  if (action is RefuserSuggestionRechercheSuccessAction) return _removingSuggestion(current, action.suggestionId);
  return current;
}

SuggestionsRechercheState _removingSuggestion(SuggestionsRechercheState current, String suggestionId) {
  if (current is! SuggestionsRechercheSuccessState) return current;
  final suggestions = current.suggestions;
  suggestions.removeWhere((element) => element.id == suggestionId);
  return SuggestionsRechercheSuccessState(suggestions);
}
