import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/redux/states/search_location_state.dart';
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

  test("create returns location result properly formatted", () {
    // Given
    final department = Location(libelle: "Paris", code: "75", codePostal: null, type: LocationType.DEPARTMENT);
    final commune = Location(libelle: "Paris 1", code: "75111", codePostal: "75001", type: LocationType.COMMUNE);
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(searchLocationState: SearchLocationState([department, commune])),
    );

    // When
    final viewModel = OffreEmploiSearchViewModel.create(store);

    // Then
    expect(viewModel.locations, [
      LocationViewModel("Paris (75)", department),
      LocationViewModel("Paris 1 (75001)", commune),
    ]);
  });

  test("create returns location result with proper toString value for autocomplete widget onSelected", () {
    // Given
    final department = Location(libelle: "Paris", code: "75", codePostal: null, type: LocationType.DEPARTMENT);
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(searchLocationState: SearchLocationState([department])),
    );

    // When
    final viewModel = OffreEmploiSearchViewModel.create(store);

    // Then
    expect(viewModel.locations.first.toString(), "Paris (75)");
  });
}
