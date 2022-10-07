import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class SuggestionsRechercheListViewModel extends Equatable {
  final List<String> suggestionIds;
  final DisplayState traiterDisplayState;
  final Function() resetTraiterState;
  final Function() seeOffreResults;

  SuggestionsRechercheListViewModel._({
    required this.suggestionIds,
    required this.traiterDisplayState,
    required this.resetTraiterState,
    required this.seeOffreResults,
  });

  factory SuggestionsRechercheListViewModel.create(Store<AppState> store) {
    return SuggestionsRechercheListViewModel._(
      suggestionIds: _ids(store),
      traiterDisplayState: _displayState(store),
      resetTraiterState: () => store.dispatch(TraiterSuggestionRechercheResetAction()),
      seeOffreResults: () => _seeOffreResults(store),
    );
  }

  @override
  List<Object?> get props => [suggestionIds, traiterDisplayState];
}

List<String> _ids(Store<AppState> store) {
  final state = store.state.suggestionsRechercheState;
  if (state is! SuggestionsRechercheSuccessState) {
    return [];
  }
  return state.suggestions.map((e) => e.id).toList();
}

DisplayState _displayState(Store<AppState> store) {
  final state = store.state.traiterSuggestionRechercheState;
  if (state is TraiterSuggestionRechercheLoadingState) return DisplayState.LOADING;
  if (state is AccepterSuggestionRechercheSuccessState) return DisplayState.CONTENT;
  return DisplayState.EMPTY;
}

void _seeOffreResults(Store<AppState> store) {
  final traiterState = store.state.traiterSuggestionRechercheState;
  if (traiterState is! AccepterSuggestionRechercheSuccessState) return;
  SavedSearchListViewModel.dispatchSearchRequest(traiterState.savedSearch, store);
}
