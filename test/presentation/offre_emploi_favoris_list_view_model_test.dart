import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_favoris_list_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

main() {
  test("create when favoris have data should show content", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiFavorisState: OffreEmploiFavorisState.withMap({"1"}, {"1": mockOffreEmploi()}),
      ),
    );

    // When
    final viewModel = OffreEmploiFavorisListViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test("create when favoris are only ids should show loader", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiFavorisState: OffreEmploiFavorisState.idsLoaded({"1"}),
      ),
    );

    // When
    final viewModel = OffreEmploiFavorisListViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("create when favoris are empty should show empty", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiFavorisState: OffreEmploiFavorisState.withMap({}, Map()),
      ),
    );

    // When
    final viewModel = OffreEmploiFavorisListViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
  });

  test("create when favoris fail to load should show error", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiFavorisState: OffreEmploiFavorisState.notInitialized(),
      ),
    );

    // When
    final viewModel = OffreEmploiFavorisListViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });
}
