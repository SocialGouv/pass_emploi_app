import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_search_results_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';

void main() {
  test("create when state is success should convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionListState: ImmersionListSuccessState([mockImmersion()]),
      ),
    );

    // When
    final viewModel = ImmersionSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [mockImmersion()]);
    expect(viewModel.errorMessage, isEmpty);
  });

  test("create when state is success but there is not data should correctly map it to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionListState: ImmersionListSuccessState([]),
      ),
    );

    // When
    final viewModel = ImmersionSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
    expect(viewModel.items, []);
    expect(viewModel.errorMessage, isEmpty);
  });

  test("create when state is loading should convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionListState: ImmersionListLoadingState(),
      ),
    );

    // When
    final viewModel = ImmersionSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
    expect(viewModel.items, []);
    expect(viewModel.errorMessage, isEmpty);
  });

  test("create when state is failure should convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionListState: ImmersionListFailureState(),
      ),
    );

    // When
    final viewModel = ImmersionSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.items, []);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });
  group("create should properly set filtre number ...", () {
    test("when state has no active filtre it should not display a filtre number", () {
      // Given
      final store = _storeWithFiltres(ImmersionSearchParametersFiltres.noFiltres());

      // When
      final viewModel = ImmersionSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test("when state has active distance filtre but value is default it should not display a filtre number", () {
      // Given
      final store = _storeWithFiltres(ImmersionSearchParametersFiltres.distance(10));

      // When
      final viewModel = ImmersionSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test("when state has active distance filtre and value is not default it should display 1 as filtre number", () {
      // Given
      final store = _storeWithFiltres(ImmersionSearchParametersFiltres.distance(90));

      // When
      final viewModel = ImmersionSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 1);
    });
  });


}

Store<AppState> _storeWithFiltres(ImmersionSearchParametersFiltres filtres) {
  return Store<AppState>(
    reducer,
    initialState: AppState.initialState().copyWith(
      immersionListState: ImmersionListSuccessState([mockImmersion()]),
      immersionSearchParametersState: ImmersionSearchParametersInitializedState(
        codeRome: "codeRome",
        location: mockCommuneLocation(),
        filtres: filtres,
      ),
    ),
  );
}
