import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class SuggestionsRechercheListViewModel extends Equatable {
  final List<String> suggestionIds;
  final DisplayState traiterDisplayState;
  final SavedSearchNavigationState searchNavigationState;
  final Function() resetTraiterState;
  final Function() seeOffreResults;

  SuggestionsRechercheListViewModel._({
    required this.suggestionIds,
    required this.traiterDisplayState,
    required this.searchNavigationState,
    required this.resetTraiterState,
    required this.seeOffreResults,
  });

  factory SuggestionsRechercheListViewModel.create(Store<AppState> store) {
    return SuggestionsRechercheListViewModel._(
      suggestionIds: _ids(store),
      traiterDisplayState: _displayState(store),
      searchNavigationState: SavedSearchNavigationState.fromAppState(store.state),
      resetTraiterState: () => store.dispatch(TraiterSuggestionRechercheResetAction()),
      seeOffreResults: () => _seeOffreResults(store),
    );
  }

  @override
  List<Object?> get props => [suggestionIds, traiterDisplayState, searchNavigationState];
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
  final state = store.state.traiterSuggestionRechercheState;
  if (state is! AccepterSuggestionRechercheSuccessState) return;
  store.dispatch(SavedSearchGetAction(state.savedSearch.getId()));
}
