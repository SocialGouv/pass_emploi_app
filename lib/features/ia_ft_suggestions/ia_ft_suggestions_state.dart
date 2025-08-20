import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche_ia_suggestion.dart';

sealed class IaFtSuggestionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IaFtSuggestionsNotInitializedState extends IaFtSuggestionsState {}

class IaFtSuggestionsLoadingState extends IaFtSuggestionsState {}

class IaFtSuggestionsFailureState extends IaFtSuggestionsState {}

class IaFtSuggestionsSuccessState extends IaFtSuggestionsState {
  final List<DemarcheIaSuggestion> suggestions;

  IaFtSuggestionsSuccessState(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}
