import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_state.dart';

TraiterSuggestionRechercheState traiterSuggestionRechercheReducer(
  TraiterSuggestionRechercheState current,
  dynamic action,
) {
  if (action is TraiterSuggestionRechercheResetAction) return TraiterSuggestionRechercheNotInitializedState();
  if (action is TraiterSuggestionRechercheLoadingAction) return TraiterSuggestionRechercheLoadingState();
  if (action is TraiterSuggestionRechercheFailureAction) return TraiterSuggestionRechercheFailureState();
  if (action is RefuserSuggestionRechercheSuccessAction) return RefuserSuggestionRechercheSuccessState();
  if (action is AccepterSuggestionRechercheSuccessAction) {
    return AccepterSuggestionRechercheSuccessState(action.alerte);
  }
  return current;
}
