import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/share_preferences/share_preferences_actions.dart';
import 'package:pass_emploi_app/features/share_preferences/update/share_preferences_update_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/partage_activite_page_view_model.dart';

import '../doubles/spies.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  group('PartageActivitePageViewModel.create when get share preferences…', () {
    test('…should show CONTENT if share preferences have data', () {
      // Given
      final store = givenState().sharePreferencesSuccess(favori: false).store();

      // When
      final viewModel = PartageActivitePageViewModel.create(store);

      // Then
      expect(viewModel.shareFavoris, false);
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('…should show LOADING if share preferences have no data yet', () {
      // Given
      final store = givenState().sharePreferencesLoading().store();

      // When
      final viewModel = PartageActivitePageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('…should show FAILURE if share preferences fails to load', () {
      // Given
      final store = givenState().sharePreferencesFailure().store();

      // When
      final viewModel = PartageActivitePageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('…should dispatch UPDATE action correctly', () async {
      // Given
      final store = StoreSpy.withState(givenState().sharePreferencesSuccess(favori: false));
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap();

      // Then
      expect(store.dispatchedAction, isA<SharePreferencesUpdateRequestAction>());
    });

    test('retry, after view model was created with failure, should dispatch a RequestUserActionsAction', () {
      // Given
      final store = StoreSpy.withState(givenState().sharePreferencesFailure());
      final viewModel = PartageActivitePageViewModel.create(store);


      // When
      viewModel.onRetry();

      // Then
      expect(store.dispatchedAction, isA<SharePreferencesRequestAction>());
    });
  });

  group('PartageActivitePageViewModel.create when update share preferences…', () {
    test('…should show CONTENT if share preferences updated data', () async {
      // Given
      final store = givenState().sharePreferencesUpdateSuccess(favori: false).store();
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap();

      // Then
      expect(viewModel.updateState, DisplayState.CONTENT);
    });

    test('…should show CONTENT if share preferences updated data', () {
      // Given
      final store = givenState().sharePreferencesUpdateLoading().store();
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap();

      // Then
      expect(viewModel.updateState, DisplayState.LOADING);
    });

    test('…should show FAILURE if share preferences fails to load', () {
      // Given
      final store = givenState().sharePreferencesUpdateFailure().store();
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap();

      // Then
      expect(viewModel.updateState, DisplayState.FAILURE);
    });
  });
}
