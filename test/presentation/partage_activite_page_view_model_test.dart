import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activite_actions.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/partage_activite_page_view_model.dart';

import '../doubles/spies.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  group('PartageActivitePageViewModel.create when get PartageActivite…', () {
    test('…should show CONTENT if PartageActivite have data', () {
      // Given
      final store = givenState().partageActiviteSuccess(favori: false).store();

      // When
      final viewModel = PartageActivitePageViewModel.create(store);

      // Then
      expect(viewModel.shareFavoris, false);
      expect(viewModel.displayState, DisplayState.contenu);
    });

    test('…should show LOADING if PartageActivite have no data yet', () {
      // Given
      final store = givenState().partageActiviteLoading().store();

      // When
      final viewModel = PartageActivitePageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.chargement);
    });

    test('…should show FAILURE if PartageActivite fails to load', () {
      // Given
      final store = givenState().partageActiviteFailure().store();

      // When
      final viewModel = PartageActivitePageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.erreur);
    });

    test('…should dispatch UPDATE action correctly', () async {
      // Given
      final store = StoreSpy.withState(givenState().partageActiviteSuccess(favori: false));
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap(false);

      // Then
      expect(store.dispatchedAction, isA<PartageActiviteUpdateRequestAction>());
    });

    test('retry, after view model was created with failure, should dispatch a PartageActiviteRequestAction', () {
      // Given
      final store = StoreSpy.withState(givenState().partageActiviteFailure());
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onRetry();

      // Then
      expect(store.dispatchedAction, isA<PartageActiviteRequestAction>());
    });
  });

  group('PartageActivitePageViewModel.create when update  PartageActivite…', () {
    test('…should show CONTENT if PartageActivite updated data', () async {
      // Given
      final store = givenState().partageActiviteUpdateSuccess(favori: false).store();
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap(true);

      // Then
      expect(viewModel.updateState, DisplayState.contenu);
    });

    test('…should show CONTENT if PartageActivite updated data', () {
      // Given
      final store = givenState().partageActiviteUpdateLoading().store();
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap(true);

      // Then
      expect(viewModel.updateState, DisplayState.chargement);
    });

    test('…should show FAILURE if PartageActivite fails to load', () {
      // Given
      final store = givenState().partageActiviteUpdateFailure().store();
      final viewModel = PartageActivitePageViewModel.create(store);

      // When
      viewModel.onPartageFavorisTap(false);

      // Then
      expect(viewModel.updateState, DisplayState.erreur);
    });
  });
}
