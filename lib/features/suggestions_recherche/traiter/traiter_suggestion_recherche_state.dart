import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';

abstract class TraiterSuggestionRechercheState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TraiterSuggestionRechercheNotInitializedState extends TraiterSuggestionRechercheState {}

class TraiterSuggestionRechercheLoadingState extends TraiterSuggestionRechercheState {}

class TraiterSuggestionRechercheFailureState extends TraiterSuggestionRechercheState {}

class TraiterSuggestionRechercheSuccessState extends TraiterSuggestionRechercheState {
  final SuggestionRecherche suggestion;
  final TraiterSuggestionType type;

  TraiterSuggestionRechercheSuccessState(this.suggestion, this.type);

  @override
  List<Object?> get props => [suggestion, type];
}
