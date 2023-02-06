import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/presentation/recherche/resultat_recherche_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('displayState', () {
    test('when recherche status is nouvelle recherche should display recherche', () {
      // Given
      final store = givenState().initialRechercheEmploiState().store();

      // When
      final viewModel = ResultatRechercheViewModel.create(store);

      // Then
      expect(viewModel.displayState, ResultatRechercheDisplayState.recherche);
    });

    test('when recherche status is update loading should display results', () {
      // Given
      final store = givenState().updateLoadingRechercheEmploiState().store();

      // When
      final viewModel = ResultatRechercheViewModel.create(store);

      // Then
      expect(viewModel.displayState, ResultatRechercheDisplayState.results);
    });

    test('when recherche status is success without result should display empty', () {
      // Given
      final store = givenState().successRechercheEmploiState(results: []).store();

      // When
      final viewModel = ResultatRechercheViewModel.create(store);

      // Then
      expect(viewModel.displayState, ResultatRechercheDisplayState.empty);
    });

    test('when recherche status is success without result should display results', () {
      // Given
      final store = givenState().successRechercheEmploiState(results: [mockOffreEmploi()]).store();

      // When
      final viewModel = ResultatRechercheViewModel.create(store);

      // Then
      expect(viewModel.displayState, ResultatRechercheDisplayState.results);
    });
  });

  group('displayState', () {
    test('when state can load more should return true', () {
      // Given
      final store = givenState().successRechercheEmploiState(canLoadMore: true).store();

      // When
      final viewModel = ResultatRechercheViewModel.create(store);

      // Then
      expect(viewModel.withLoadMore, isTrue);
    });

    test('when state cannot load more should return false', () {
      // Given
      final store = givenState().successRechercheEmploiState(canLoadMore: false).store();

      // When
      final viewModel = ResultatRechercheViewModel.create(store);

      // Then
      expect(viewModel.withLoadMore, isFalse);
    });
  });

  test('items should transform OffreEmploi to OffreEmploiItemViewModel', () {
    // Given
    final store = givenState().successRechercheEmploiState(results: [mockOffreEmploi()]).store();

    // When
    final viewModel = ResultatRechercheViewModel.create(store);

    // Then
    expect(viewModel.items, [mockOffreEmploiItemViewModel()]);
  });

  test('onLoadMore should dispatch proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = ResultatRechercheViewModel.create(store);

    // When
    viewModel.onLoadMore();

    // Then
    expect(store.dispatchedAction, isA<RechercheLoadMoreAction<OffreEmploi>>());
  });
}
