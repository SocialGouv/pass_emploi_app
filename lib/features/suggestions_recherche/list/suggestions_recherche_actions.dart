import 'package:pass_emploi_app/models/suggestion_recherche.dart';
//TODO(1418): Est-ce qu'on le fait bien sur notre nouveau système ?
class SuggestionsRechercheRequestAction {}

class SuggestionsRechercheLoadingAction {}

class SuggestionsRechercheFailureAction {}

class SuggestionsRechercheSuccessAction {
  final List<SuggestionRecherche> suggestions;

  SuggestionsRechercheSuccessAction(this.suggestions);
}
