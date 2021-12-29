import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

main() {
  test("create when search state is success should display success", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.success(),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiFiltresDisplayState.SUCCESS);
  });

  test("create when search state is loading should display loading", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.loading(),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiFiltresDisplayState.LOADING);
  });

  test("create when search state is failure should display success", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.failure(),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiFiltresDisplayState.FAILURE);
  });

  test("create when state has no filter should set distance to 10km", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
          "mots clés",
          mockCommuneLocation(),
          OffreEmploiSearchParametersFiltres.noFiltres(),
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 10);
  });

  test("create when state distance filter set  should set distance", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
          "mots clés",
          mockCommuneLocation(),
          OffreEmploiSearchParametersFiltres.withFiltres(distance: 20),
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 20);
  });

  test("create when search location is a departement should not display distance filter", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
          "mots clés",
          mockLocation(),
          OffreEmploiSearchParametersFiltres.noFiltres(),
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, isFalse);
  });

  test("create when search location is a commune should display distance filter", () {
// Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
          "mots clés",
          mockCommuneLocation(),
          OffreEmploiSearchParametersFiltres.noFiltres(),
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, isTrue);
  });
}
