import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/presentation/saved_search_card_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';
import '../utils/expects.dart';

void main() {
  test("ViewModel should set navigation to offres emploi when search results are ready", () {
    // Given
    final store = givenState().successRechercheEmploiState().store();

    // When
    final viewModel = SavedSearchCardViewModel.create(store);

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.OFFRE_EMPLOI);
  });

  test("ViewModel should set navigation to offres alternances when search results are ready", () {
    // Given
    final store = givenState()
        .successRechercheEmploiStateWithRequest(
          criteres: EmploiCriteresRecherche(
            keyword: "keyword",
            location: null,
            onlyAlternance: true,
          ),
        )
        .store();

    // When
    final viewModel = SavedSearchCardViewModel.create(store);

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.OFFRE_ALTERNANCE);
  });

  test("ViewModel should set navigation to offres immersions when search results are ready", () {
    // Given
    final store = givenState().successRechercheImmersionState().store();

    // When
    final viewModel = SavedSearchCardViewModel.create(store);

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.OFFRE_IMMERSION);
  });

  test("ViewModel should set navigation to service civique when search results are ready", () {
    // Given
    final store = givenState().successRechercheServiceCiviqueState().store();

    // When
    final viewModel = SavedSearchCardViewModel.create(store);

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.SERVICE_CIVIQUE);
  });

  test('fetchSavedSearchResult should dispatch FetchSavedSearchResultsAction with saved search', () {
    // Given
    final store = givenState().spyStore();
    final viewModel = SavedSearchCardViewModel.create(store);

    // When
    viewModel.fetchSavedSearchResult(mockOffreEmploiSavedSearch());

    // Then
    expectTypeThen<FetchSavedSearchResultsAction>(store.dispatchedAction, (action) {
      expect(action.savedSearch, mockOffreEmploiSavedSearch());
    });
  });
}
