import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

abstract class TraiterSuggestionRechercheState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TraiterSuggestionRechercheNotInitializedState extends TraiterSuggestionRechercheState {}

class TraiterSuggestionRechercheLoadingState extends TraiterSuggestionRechercheState {}

class TraiterSuggestionRechercheFailureState extends TraiterSuggestionRechercheState {}

class AccepterSuggestionRechercheSuccessState extends TraiterSuggestionRechercheState {
  final SavedSearch savedSearch;

  AccepterSuggestionRechercheSuccessState(this.savedSearch);

  @override
  List<Object?> get props => [savedSearch];
}

class RefuserSuggestionRechercheSuccessState extends TraiterSuggestionRechercheState {}
