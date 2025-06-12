import 'package:pass_emploi_app/features/ia_ft_suggestions/ia_ft_suggestions_actions.dart';
import 'package:pass_emploi_app/features/ia_ft_suggestions/ia_ft_suggestions_state.dart';

IaFtSuggestionsState iaFtSuggestionsReducer(IaFtSuggestionsState current, dynamic action) {
  if (action is IaFtSuggestionsLoadingAction) return IaFtSuggestionsLoadingState();
  if (action is IaFtSuggestionsFailureAction) return IaFtSuggestionsFailureState();
  if (action is IaFtSuggestionsSuccessAction) return IaFtSuggestionsSuccessState(action.suggestions);
  return current;
}
