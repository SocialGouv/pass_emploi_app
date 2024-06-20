import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_state.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_state.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_navigation_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class SuggestionsRechercheListViewModel extends Equatable {
  final DisplayState displayState;
  final List<String> suggestionIds;
  final LoginMode? loginMode;
  final DisplayState traiterDisplayState;
  final AlerteNavigationState searchNavigationState;
  final Function() resetTraiterState;
  final Function() seeOffreResults;
  final Function() retryFetchSuggestions;

  SuggestionsRechercheListViewModel._({
    required this.displayState,
    required this.suggestionIds,
    required this.loginMode,
    required this.traiterDisplayState,
    required this.searchNavigationState,
    required this.resetTraiterState,
    required this.seeOffreResults,
    required this.retryFetchSuggestions,
  });

  factory SuggestionsRechercheListViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    return SuggestionsRechercheListViewModel._(
      displayState: _displayState(store),
      suggestionIds: _ids(store),
      loginMode: loginState is LoginSuccessState ? loginState.user.loginMode : null,
      traiterDisplayState: _traiterDisplayState(store),
      searchNavigationState: AlerteNavigationState.fromAppState(store.state),
      resetTraiterState: () => store.dispatch(TraiterSuggestionRechercheResetAction()),
      seeOffreResults: () => _seeOffreResults(store),
      retryFetchSuggestions: () => store.dispatch(SuggestionsRechercheRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, suggestionIds, traiterDisplayState, searchNavigationState];
}

List<String> _ids(Store<AppState> store) {
  final state = store.state.suggestionsRechercheState;
  if (state is! SuggestionsRechercheSuccessState) {
    return [];
  }
  return state.suggestions.map((e) => e.id).toList();
}

DisplayState _displayState(Store<AppState> store) {
  final state = store.state.suggestionsRechercheState;
  return switch (state) {
    SuggestionsRechercheNotInitializedState() => DisplayState.FAILURE,
    SuggestionsRechercheLoadingState() => DisplayState.LOADING,
    SuggestionsRechercheFailureState() => DisplayState.FAILURE,
    final SuggestionsRechercheSuccessState e => e.suggestions.isEmpty ? DisplayState.EMPTY : DisplayState.CONTENT,
  };
}

DisplayState _traiterDisplayState(Store<AppState> store) {
  final state = store.state.traiterSuggestionRechercheState;
  if (state is TraiterSuggestionRechercheLoadingState) return DisplayState.LOADING;
  if (state is AccepterSuggestionRechercheSuccessState) return DisplayState.CONTENT;
  return DisplayState.EMPTY;
}

void _seeOffreResults(Store<AppState> store) {
  final state = store.state.traiterSuggestionRechercheState;
  if (state is! AccepterSuggestionRechercheSuccessState) return;
  store.dispatch(FetchAlerteResultsFromIdAction(state.alerte.getId()));
}
