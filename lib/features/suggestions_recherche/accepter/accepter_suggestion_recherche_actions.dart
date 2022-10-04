import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';

enum TraiterSuggestionType { accepter, refuser }

class AccepterSuggestionRechercheRequestAction extends Equatable {
  final SuggestionRecherche suggestion;
  final TraiterSuggestionType type;

  AccepterSuggestionRechercheRequestAction(this.suggestion, this.type);

  @override
  List<Object?> get props => [suggestion, type];
}

class AccepterSuggestionRechercheLoadingAction {}

class AccepterSuggestionRechercheFailureAction {}

class AccepterSuggestionRechercheSuccessAction {
  final SuggestionRecherche suggestion;
  final TraiterSuggestionType type;

  AccepterSuggestionRechercheSuccessAction(this.suggestion, this.type);
}
