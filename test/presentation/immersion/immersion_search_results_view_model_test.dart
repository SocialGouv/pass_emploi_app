import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_search_results_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';

main() {
  test("create when state is success should convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionSearchState: State<List<Immersion>>.success([mockImmersion()]),
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
        immersionSearchState: State<List<Immersion>>.success([]),
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
        immersionSearchState: State<List<Immersion>>.loading(),
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
        immersionSearchState: State<List<Immersion>>.failure(),
      ),
    );

    // When
    final viewModel = ImmersionSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.items, []);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });

  test("filtres count should be null always", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionSearchState: State<List<Immersion>>.success([mockImmersion()]),
      ),
    );

    // When
    final viewModel = ImmersionSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.filtresCount, isNull);
  });
}
