import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/preferences/preferences_actions.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/partage_activite_page_view_model.dart';

import '../doubles/spies.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  group('PartageActivitePageViewModel.create when get PartageActivite…', () {
    test('…should show CONTENT if PartageActivite have data', () {
      // Given
      final store = givenState().preferencesSuccess(favori: false).store();

      // When
      final viewModel = PartageActivitePageViewModel.create(store);

      // Then
      expect(viewModel.shareFavoris, false);
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('…should show LOADING if PartageActivite have no data yet', () {
      // Given
      final store = givenState().preferencesLoading().store();

      // When
      final viewModel = PartageActivitePageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('…should show FAILURE if PartageActivite fails to load', () {
      // Given
      final store = givenState().preferencesFailure().store();

      // When
      final viewModel = PartageActivitePageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('…should dispatch UPDATE action correctly', () async {
      // Given
      final store = StoreSpy.withState(givenState().preferencesSuccess(favori: false));
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap(false);

      // Then
      expect(store.dispatchedAction, isA<PreferencesUpdateRequestAction>());
    });

    test('retry, after view model was created with failure, should dispatch a PartageActiviteRequestAction', () {
      // Given
      final store = StoreSpy.withState(givenState().preferencesFailure());
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onRetry();

      // Then
      expect(store.dispatchedAction, isA<PreferencesRequestAction>());
    });
  });

  group('PartageActivitePageViewModel.create when update  PartageActivite…', () {
    test('…should show CONTENT if PartageActivite updated data', () async {
      // Given
      final store = givenState().preferencesUpdateSuccess().store();
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap(true);

      // Then
      expect(viewModel.updateState, DisplayState.CONTENT);
    });

    test('…should show CONTENT if PartageActivite updated data', () {
      // Given
      final store = givenState().preferencesUpdateLoading().store();
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap(true);

      // Then
      expect(viewModel.updateState, DisplayState.LOADING);
    });

    test('…should show FAILURE if PartageActivite fails to load', () {
      // Given
      final store = givenState().preferencesUpdateFailure().store();
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap(false);

      // Then
      expect(viewModel.updateState, DisplayState.FAILURE);
    });
  });
}
