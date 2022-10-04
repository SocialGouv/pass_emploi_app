import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';

abstract class AccepterSuggestionRechercheState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccepterSuggestionRechercheNotInitializedState extends AccepterSuggestionRechercheState {}

class AccepterSuggestionRechercheLoadingState extends AccepterSuggestionRechercheState {}

class AccepterSuggestionRechercheFailureState extends AccepterSuggestionRechercheState {}

class AccepterSuggestionRechercheSuccessState extends AccepterSuggestionRechercheState {
  final SuggestionRecherche suggestion;
  final TraiterSuggestionType type;

  AccepterSuggestionRechercheSuccessState(this.suggestion, this.type);

  @override
  List<Object?> get props => [suggestion, type];
}
