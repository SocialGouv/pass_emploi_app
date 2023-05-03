import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/presentation/saved_search_navigator_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  test("ViewModel should set navigation to offres emploi when search results are ready", () {
    // Given
    final store = givenState().successRechercheEmploiState().store();

    // When
    final viewModel = SavedSearchNavigatorViewModel.create(store);

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
            rechercheType: RechercheType.onlyAlternance,
          ),
        )
        .store();

    // When
    final viewModel = SavedSearchNavigatorViewModel.create(store);

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.OFFRE_ALTERNANCE);
  });

  test("ViewModel should set navigation to offres immersions when search results are ready", () {
    // Given
    final store = givenState().successRechercheImmersionState().store();

    // When
    final viewModel = SavedSearchNavigatorViewModel.create(store);

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.OFFRE_IMMERSION);
  });

  test("ViewModel should set navigation to service civique when search results are ready", () {
    // Given
    final store = givenState().successRechercheServiceCiviqueState().store();

    // When
    final viewModel = SavedSearchNavigatorViewModel.create(store);

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.SERVICE_CIVIQUE);
  });
}
