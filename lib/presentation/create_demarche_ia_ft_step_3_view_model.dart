import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/ia_ft_suggestions/ia_ft_suggestions_state.dart';
import 'package:pass_emploi_app/models/demarche_ia_suggestion.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarcheIaFtStep3ViewModel extends Equatable {
  final DisplayState displayState;
  final List<DemarcheIaSuggestion> suggestions;

  CreateDemarcheIaFtStep3ViewModel({
    required this.displayState,
    required this.suggestions,
  });

  factory CreateDemarcheIaFtStep3ViewModel.create(Store<AppState> store) {
    final iaFtSuggestionsState = store.state.iaFtSuggestionsState;
    return CreateDemarcheIaFtStep3ViewModel(
      displayState: _viewModel(iaFtSuggestionsState),
      suggestions: _suggestions(iaFtSuggestionsState),
    );
  }

  @override
  List<Object?> get props => [displayState, suggestions];
}

DisplayState _viewModel(IaFtSuggestionsState iaFtSuggestionsState) {
  return switch (iaFtSuggestionsState) {
    IaFtSuggestionsNotInitializedState() => DisplayState.LOADING,
    IaFtSuggestionsLoadingState() => DisplayState.LOADING,
    IaFtSuggestionsSuccessState() => DisplayState.CONTENT,
    IaFtSuggestionsFailureState() => DisplayState.FAILURE,
  };
}

List<DemarcheIaSuggestion> _suggestions(IaFtSuggestionsState iaFtSuggestionsState) {
  return switch (iaFtSuggestionsState) {
    IaFtSuggestionsSuccessState(suggestions: final suggestions) => suggestions,
    _ => [],
  };
}
