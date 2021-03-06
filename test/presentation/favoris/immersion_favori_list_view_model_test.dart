import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';

void main() {
  test("create when favoris have data should show content", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionFavorisState: FavoriListState<Immersion>.withMap({"1"}, {"1": mockImmersion()}),
      ),
    );

    // When
    final viewModel = FavorisListViewModel.createForImmersion(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test("create when favoris are only ids should show loader", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionFavorisState: FavoriListState<Immersion>.idsLoaded({"1"}),
      ),
    );

    // When
    final viewModel = FavorisListViewModel.createForImmersion(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("create when favoris are empty should show empty", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionFavorisState: FavoriListState<Immersion>.withMap({}, {}),
      ),
    );

    // When
    final viewModel = FavorisListViewModel.createForImmersion(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
  });

  test("create when favoris fail to load should show error", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionFavorisState: FavoriListState<Immersion>.notInitialized(),
      ),
    );

    // When
    final viewModel = FavorisListViewModel.createForImmersion(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test("create when favoris have data should format offre items", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionFavorisState: FavoriListState<Immersion>.withMap(
          {'1', '2'},
          {
            '1': mockImmersion(id: '1'),
            '2': mockImmersion(id: '2'),
          },
        ),
      ),
    );

    // When
    final viewModel = FavorisListViewModel.createForImmersion(store);

    // Then
    expect(
      viewModel.items,
      [
        mockImmersion(id: '1'),
        mockImmersion(id: '2'),
      ],
    );
  });

  test('View model triggers ImmersionSearchFailureAction when onRetry is performed', () {
    // Given
    final store = StoreSpy();
    final viewModel = FavorisListViewModel.createForImmersion(store);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction is FavoriListRequestAction<Immersion>, isTrue);
  });
}
