import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_results_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

import '../models/offre_emploi_test.dart';

main() {
  group("create when state is success should convert data to view model", () {
    Store<AppState> _successSetUp({required bool moreData}) {
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiSearchState: OffreEmploiSearchState.success(),
          offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(
              offres: offreEmploiData(), loadedPage: 1, isMoreDataAvailable: moreData),
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
      expect(viewModel.displayState, OffreEmploiSearchResultsDisplayState.SHOW_CONTENT);
      expect(viewModel.items, _expectedViewModels());
      expect(viewModel.displayLoaderAtBottomOfList, true);
    });

    test("and no more data available", () {
      // Given
      final store = _successSetUp(moreData: false);

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.displayState, OffreEmploiSearchResultsDisplayState.SHOW_CONTENT);
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
            OffreEmploiSearchResultsState.data(offres: offreEmploiData(), loadedPage: 2, isMoreDataAvailable: false),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiSearchResultsDisplayState.SHOW_LOADER);
    expect(viewModel.items, _expectedViewModels());
  });

  test("create when state is failure should convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.failure(),
        offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(
          offres: offreEmploiData(),
          loadedPage: 3,
          isMoreDataAvailable: false,
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiSearchResultsDisplayState.SHOW_ERROR);
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
    ),
    OffreEmploiItemViewModel(
      "123DXPK",
      " #SALONDEMANDELIEU2021: RECEPTIONNISTE TOURNANT (H/F)",
      "STAND CHATEAU DE LA BEGUDE",
      "CDD",
      "Temps partiel",
      "06 - OPIO",
    ),
    OffreEmploiItemViewModel(
      "123DXPG",
      "Technicien / Technicienne terrain Structure          (H/F)",
      "GEOTEC",
      "CDI",
      "Temps plein",
      "78 - PLAISIR",
    ),
    OffreEmploiItemViewModel(
      "123DXPF",
      "Responsable de boutique",
      "GINGER",
      "CDD",
      null,
      "13 - AIX EN PROVENCE",
    ),
    OffreEmploiItemViewModel(
      "123DXLK",
      "Commercial sédentaire en Assurances H/F",
      null,
      "CDI",
      "Temps plein",
      "34 - MONTPELLIER",
    )
  ];
}
