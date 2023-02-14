import 'package:pass_emploi_app/models/suggestion_recherche.dart';

class SuggestionsRechercheRequestAction {}

class SuggestionsRechercheLoadingAction {}

class SuggestionsRechercheFailureAction {}

class SuggestionsRechercheSuccessAction {
  final List<SuggestionRecherche> suggestions;

  SuggestionsRechercheSuccessAction(this.suggestions);
}
