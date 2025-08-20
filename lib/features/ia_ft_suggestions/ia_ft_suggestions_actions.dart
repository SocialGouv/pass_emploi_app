import 'package:pass_emploi_app/models/demarche_ia_suggestion.dart';

class IaFtSuggestionsRequestAction {
  final String query;

  IaFtSuggestionsRequestAction({required this.query});
}

class IaFtSuggestionsLoadingAction {}

class IaFtSuggestionsSuccessAction {
  final List<DemarcheIaSuggestion> suggestions;

  IaFtSuggestionsSuccessAction(this.suggestions);
}

class IaFtSuggestionsFailureAction {}
