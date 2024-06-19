import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestions_recherche_list_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  test("should display loading when loading", () {
    // Given
    final store = givenState().failedSuggestionsRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, []);
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test("should display loading when loading", () {
    // Given
    final store = givenState().loadingSuggestionsRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("should display empty when no suggestion", () {
    // Given
    final store = givenState().emptySuggestionsRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, []);
    expect(viewModel.displayState, DisplayState.EMPTY);
  });

  test("should display content with suggestions when init", () {
    // Given
    final store = givenState().withSuggestionsRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, ["1", "2"]);
    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test("should display traiter empty with suggestions when not init", () {
    // Given
    final store = givenState().withSuggestionsRecherche().notInitTraiterSuggestionRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, isNotEmpty);
    expect(viewModel.traiterDisplayState, DisplayState.EMPTY);
  });

  test("should display traiter loading with suggestions when loading", () {
    // Given
    final store = givenState().withSuggestionsRecherche().loadingTraiterSuggestionRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, isNotEmpty);
    expect(viewModel.traiterDisplayState, DisplayState.LOADING);
  });

  test("should display traiter content with suggestions when succeed accepter", () {
    // Given
    final store = givenState().withSuggestionsRecherche().succeedAccepterSuggestionRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, isNotEmpty);
    expect(viewModel.traiterDisplayState, DisplayState.CONTENT);
  });

  test("should display traiter empty with suggestions when succeed refuser", () {
    // Given
    final store = givenState().withSuggestionsRecherche().succeedRefuserSuggestionRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, isNotEmpty);
    expect(viewModel.traiterDisplayState, DisplayState.EMPTY);
  });

  test("should display traiter empty with suggestions when fail", () {
    // Given
    final store = givenState().withSuggestionsRecherche().failedTraiterSuggestionRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, isNotEmpty);
    expect(viewModel.traiterDisplayState, DisplayState.EMPTY);
  });

  test("should retry fetch", () {
    // Given
    final store = givenState().failedSuggestionsRecherche().spyStore();
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // When
    viewModel.retryFetchSuggestions();

    // Then
    expect(store.dispatchedAction, isA<SuggestionsRechercheRequestAction>());
  });

  test("should reset traiter state", () {
    // Given
    final store = givenState().withSuggestionsRecherche().succeedAccepterSuggestionRecherche().spyStore();
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // When
    viewModel.resetTraiterState();

    // Then
    expect(store.dispatchedAction, isA<TraiterSuggestionRechercheResetAction>());
  });

  test("should see offre results", () {
    // Given
    final store = givenState().succeedAccepterSuggestionRecherche().spyStore();
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // When
    viewModel.seeOffreResults();

    // Then
    expect(store.dispatchedAction, isA<FetchAlerteResultsFromIdAction>());
    expect((store.dispatchedAction as FetchAlerteResultsFromIdAction).alerteId, 'id');
  });

  test("should have login mode milo", () {
    // Given
    final store = givenState().loggedInMiloUser().spyStore();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.loginMode, LoginMode.MILO);
  });

  test("should have login mode pole emploi", () {
    // Given
    final store = givenState().loggedInPoleEmploiUser().spyStore();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.loginMode, LoginMode.POLE_EMPLOI);
  });
}
