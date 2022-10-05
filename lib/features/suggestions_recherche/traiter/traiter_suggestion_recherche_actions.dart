import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';

enum TraiterSuggestionType { accepter, refuser }

class TraiterSuggestionRechercheRequestAction extends Equatable {
  final SuggestionRecherche suggestion;
  final TraiterSuggestionType type;

  TraiterSuggestionRechercheRequestAction(this.suggestion, this.type);

  @override
  List<Object?> get props => [suggestion, type];
}

class TraiterSuggestionRechercheLoadingAction {}

class TraiterSuggestionRechercheFailureAction {}

class TraiterSuggestionRechercheSuccessAction {
  final SuggestionRecherche suggestion;
  final TraiterSuggestionType type;

  TraiterSuggestionRechercheSuccessAction(this.suggestion, this.type);
}
