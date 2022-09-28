import 'package:pass_emploi_app/models/suggestion_recherche.dart';

class AccepterSuggestionRechercheRequestAction {
  final SuggestionRecherche suggestion;

  AccepterSuggestionRechercheRequestAction(this.suggestion);
}

class AccepterSuggestionRechercheLoadingAction {}

class AccepterSuggestionRechercheFailureAction {}

class AccepterSuggestionRechercheSuccessAction {
  final SuggestionRecherche suggestion;

  AccepterSuggestionRechercheSuccessAction(this.suggestion);
}
