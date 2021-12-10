import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

main() {
  test("create when state is loading should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.loading(),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiSearchDisplayState.SHOW_LOADER);
    expect(viewModel.errorMessage, "");
  });

  test("create when state is failure should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.failure(),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiSearchDisplayState.SHOW_ERROR);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });

  test("create when state is success but empty should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.success(),
        offreEmploiSearchResultsState:
            OffreEmploiSearchResultsState.data(offres: [], loadedPage: 1, isMoreDataAvailable: false),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiSearchDisplayState.SHOW_EMPTY_ERROR);
    expect(viewModel.errorMessage, "Aucune offre ne correspond à votre recherche");
  });

  test("create when state is success and not empty should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.success(),
        offreEmploiSearchResultsState:
            OffreEmploiSearchResultsState.data(offres: [mockOffreEmploi()], loadedPage: 1, isMoreDataAvailable: false),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiSearchDisplayState.SHOW_CONTENT);
    expect(viewModel.errorMessage, "");
  });

}
