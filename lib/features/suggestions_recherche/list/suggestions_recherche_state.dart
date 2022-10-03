import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';

abstract class SuggestionsRechercheState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SuggestionsRechercheNotInitializedState extends SuggestionsRechercheState {}

class SuggestionsRechercheLoadingState extends SuggestionsRechercheState {}

class SuggestionsRechercheFailureState extends SuggestionsRechercheState {}

class SuggestionsRechercheSuccessState extends SuggestionsRechercheState {
  final List<SuggestionRecherche> suggestions;

  SuggestionsRechercheSuccessState(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}
