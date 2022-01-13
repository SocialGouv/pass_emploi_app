import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_favoris_list_view_model.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

main() {
  group('create when not only alternance…', () {
    test("and favoris have data should show content", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiFavorisState: OffreEmploiFavorisState.withMap({"1"}, {"1": mockOffreEmploi(isAlternance: false)}),
        ),
      );

      // When
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: false);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test("and favoris are only ids should show loader", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiFavorisState: OffreEmploiFavorisState.idsLoaded({"1"}),
        ),
      );

      // When
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: false);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test("and favoris are empty should show empty", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiFavorisState: OffreEmploiFavorisState.withMap({}, Map()),
        ),
      );

      // When
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: false);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
    });

    test("and favoris fail to load should show error", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiFavorisState: OffreEmploiFavorisState.notInitialized(),
        ),
      );

      // When
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: false);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test("and favoris have data should format offre items", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiFavorisState: OffreEmploiFavorisState.withMap(
            {'1', '2'},
            {
              '1': mockOffreEmploi(id: '1', isAlternance: false),
              '2': mockOffreEmploi(id: '2', isAlternance: false),
            },
          ),
        ),
      );

      // When
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: false);

      // Then
      expect(
        viewModel.items,
        [
          mockOffreEmploiItemViewModel(id: '1'),
          mockOffreEmploiItemViewModel(id: '2'),
        ],
      );
    });

    test('View model triggers ImmersionSearchFailureAction when onRetry is performed', () {
      final store = StoreSpy();
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: false);

      viewModel.onRetry();

      expect(store.dispatchedAction is RequestOffreEmploiFavorisAction, isTrue);
    });
  });

  group('create when only alternance…', () {
    test("and favoris have alternance data should show content", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiFavorisState: OffreEmploiFavorisState.withMap({"1"}, {"1": mockOffreEmploi(isAlternance: true)}),
        ),
      );

      // When
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: true);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test("and favoris do not have alternance data should show empty", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiFavorisState: OffreEmploiFavorisState.withMap({"1"}, {"1": mockOffreEmploi(isAlternance: false)}),
        ),
      );

      // When
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: true);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
    });

    test("and favoris are only ids should show loader", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiFavorisState: OffreEmploiFavorisState.idsLoaded({"1"}),
        ),
      );

      // When
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: true);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test("and favoris are empty should show empty", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiFavorisState: OffreEmploiFavorisState.withMap({}, Map()),
        ),
      );

      // When
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: true);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
    });

    test("and favoris fail to load should show error", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiFavorisState: OffreEmploiFavorisState.notInitialized(),
        ),
      );

      // When
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: true);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test("and favoris have data should only keep alternance favoris and format offre items", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiFavorisState: OffreEmploiFavorisState.withMap(
            {'1', '2'},
            {
              '1': mockOffreEmploi(id: '1', isAlternance: false),
              '2': mockOffreEmploi(id: '2', isAlternance: true),
            },
          ),
        ),
      );

      // When
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: true);

      // Then
      expect(viewModel.items, [mockOffreEmploiItemViewModel(id: '2')]);
    });

    test('View model triggers ImmersionSearchFailureAction when onRetry is performed', () {
      final store = StoreSpy();
      final viewModel = OffreEmploiFavorisListViewModel.create(store, onlyAlternance: true);

      viewModel.onRetry();

      expect(store.dispatchedAction is RequestOffreEmploiFavorisAction, isTrue);
    });
  });
}
