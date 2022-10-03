import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class SuggestionsRechercheListViewModel extends Equatable {
  final List<String> suggestionIds;
  final DisplayState displayState;

  SuggestionsRechercheListViewModel._({required this.suggestionIds, required this.displayState});

  factory SuggestionsRechercheListViewModel.create(Store<AppState> store) {
    return SuggestionsRechercheListViewModel._(
      suggestionIds: _ids(store),
      displayState: _displayState(store),
    );
  }

  @override
  List<Object?> get props => [suggestionIds, displayState];
}

List<String> _ids(Store<AppState> store) {
  final state = store.state.suggestionsRechercheState;
  if (state is! SuggestionsRechercheSuccessState) {
    return [];
  }
  return state.suggestions.map((e) => e.id).toList();
}

DisplayState _displayState(Store<AppState> store) {
  final state = store.state.accepterSuggestionRechercheState;
  if (state is AccepterSuggestionRechercheLoadingState) return DisplayState.LOADING;
  return DisplayState.CONTENT;
}
