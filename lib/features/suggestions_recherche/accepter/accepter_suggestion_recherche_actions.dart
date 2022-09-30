import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';

class AccepterSuggestionRechercheRequestAction extends Equatable {
  final SuggestionRecherche suggestion;

  AccepterSuggestionRechercheRequestAction(this.suggestion);

  @override
  List<Object?> get props => [suggestion];
}

class AccepterSuggestionRechercheLoadingAction {}

class AccepterSuggestionRechercheFailureAction {}

class AccepterSuggestionRechercheSuccessAction {
  final SuggestionRecherche suggestion;

  AccepterSuggestionRechercheSuccessAction(this.suggestion);
}
