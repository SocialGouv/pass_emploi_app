import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestions_recherche_list_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {

  test("should display content with suggestions when init", () {
    // Given
    final store = givenState().withSuggestionsRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, ["1", "2"]);
  });

  test("should display loading with suggestions when loading", () {
    // Given
    final store = givenState().withSuggestionsRecherche().loadingAccepterSuggestionRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, isNotEmpty);
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("should display content with suggestions when succeed", () {
    // Given
    final store = givenState().withSuggestionsRecherche().succeedAccepterSuggestionRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, isNotEmpty);
    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test("should display content with suggestions when fail", () {
    // Given
    final store = givenState().withSuggestionsRecherche().failedAccepterSuggestionRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestionIds, isNotEmpty);
    expect(viewModel.displayState, DisplayState.CONTENT);
  });
}
