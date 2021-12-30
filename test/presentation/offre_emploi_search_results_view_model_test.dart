import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_results_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

main() {
  group("create when state is success should convert data to view model", () {
    Store<AppState> _successSetUp({required bool moreData}) {
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiSearchState: OffreEmploiSearchState.success(),
          offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(
              offres: [mockOffreEmploi()], loadedPage: 1, isMoreDataAvailable: moreData),
        ),
      );
      return store;
    }

    test("and more data is available", () {
      // Given
      final store = _successSetUp(moreData: true);

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.items, _expectedViewModels());
      expect(viewModel.displayLoaderAtBottomOfList, true);
    });

    test("and no more data available", () {
      // Given
      final store = _successSetUp(moreData: false);

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.items, _expectedViewModels());
      expect(viewModel.displayLoaderAtBottomOfList, false);
    });
  });

  test("create when state is loading should convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.loading(),
        offreEmploiSearchResultsState:
            OffreEmploiSearchResultsState.data(offres: [mockOffreEmploi()], loadedPage: 2, isMoreDataAvailable: false),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
    expect(viewModel.items, _expectedViewModels());
  });

  test("create when state is failure should convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.failure(),
        offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(
          offres: [mockOffreEmploi()],
          loadedPage: 3,
          isMoreDataAvailable: false,
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.items, _expectedViewModels());
  });
}

List<OffreEmploiItemViewModel> _expectedViewModels() {
  return [
    OffreEmploiItemViewModel(
      "123DXPM",
      "Technicien / Technicienne en froid et climatisation",
      "RH TT INTERIM",
      "MIS",
      "Temps plein",
      "77 - LOGNES",
    )
  ];
}
