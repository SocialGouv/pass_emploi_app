import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_router_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:redux/redux.dart';

import '../models/offre_emploi_test.dart';

main() {
  test("create when search results are not initialized should display search screen", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState()
          .copyWith(offreEmploiSearchResultsState: OffreEmploiSearchResultsState.notInitialized()),
    );

    // When
    final viewModel = OffreEmploiRouterViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiRouterDisplayState.SHOW_SEARCH);
  });

  test("create when search results are initialized with data should display list screen", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
          offreEmploiSearchResultsState:
              OffreEmploiSearchResultsState.data(offres: offreEmploiData(), loadedPage: 1, isMoreDataAvailable: true)),
    );

    // When
    final viewModel = OffreEmploiRouterViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiRouterDisplayState.SHOW_LIST);
  });

  test("create when search results are initialized with empty list should display search screen (to display error)", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
          offreEmploiSearchResultsState:
              OffreEmploiSearchResultsState.data(offres: [], loadedPage: 1, isMoreDataAvailable: true)),
    );

    // When
    final viewModel = OffreEmploiRouterViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiRouterDisplayState.SHOW_SEARCH);
  });
}
