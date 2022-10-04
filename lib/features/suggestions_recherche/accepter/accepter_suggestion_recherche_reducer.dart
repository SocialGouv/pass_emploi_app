import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_state.dart';

AccepterSuggestionRechercheState accepterSuggestionRechercheReducer(
  AccepterSuggestionRechercheState current,
  dynamic action,
) {
  if (action is AccepterSuggestionRechercheLoadingAction) return AccepterSuggestionRechercheLoadingState();
  if (action is AccepterSuggestionRechercheFailureAction) return AccepterSuggestionRechercheFailureState();
  if (action is AccepterSuggestionRechercheSuccessAction) {
    return AccepterSuggestionRechercheSuccessState(action.suggestion, action.type);
  }
  return current;
}
