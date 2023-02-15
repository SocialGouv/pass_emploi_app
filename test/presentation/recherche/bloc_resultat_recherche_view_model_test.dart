import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('displayState', () {
    test('when recherche status is update loading should display results', () {
      // Given
      final store = givenState().updateLoadingRechercheEmploiState().store();

      // When
      final viewModel = _makeViewModel(store);

      // Then
      expect(viewModel.displayState, BlocResultatRechercheDisplayState.results);
    });

    group('when recherche status is nouvelle recherche', () {
      test('and result is null should display recherche', () {
        // Given
        givenState().withRechercheEmploiState(
          status: RechercheStatus.nouvelleRecherche,
          results: null,
        );
        final store = givenState().initialRechercheEmploiState().store();

        // When
        final viewModel = _makeViewModel(store);

        // Then
        expect(viewModel.displayState, BlocResultatRechercheDisplayState.recherche);
      });

      test('and result is empty should display empty', () {
        // Given
        final store = givenState().initialRechercheEmploiState().store();

        // When
        final viewModel = _makeViewModel(store);

        // Then
        expect(viewModel.displayState, BlocResultatRechercheDisplayState.recherche);
      });
    });

    group('when recherche status is success', () {
      test('and result is empty should display empty', () {
        // Given
        final store = givenState().successRechercheEmploiState(results: []).store();

        // When
        final viewModel = _makeViewModel(store);

        // Then
        expect(viewModel.displayState, BlocResultatRechercheDisplayState.empty);
      });

      test('and result is not empty should display results', () {
        // Given
        final store = givenState().successRechercheEmploiState(results: [mockOffreEmploi()]).store();

        // When
        final viewModel = _makeViewModel(store);

        // Then
        expect(viewModel.displayState, BlocResultatRechercheDisplayState.results);
      });
    });
  });

  group('withLoadMore', () {
    test('when state can load more should return true', () {
      // Given
      final store = givenState().successRechercheEmploiState(canLoadMore: true).store();

      // When
      final viewModel = _makeViewModel(store);

      // Then
      expect(viewModel.withLoadMore, isTrue);
    });

    test('when state cannot load more should return false', () {
      // Given
      final store = givenState().successRechercheEmploiState(canLoadMore: false).store();

      // When
      final viewModel = _makeViewModel(store);

      // Then
      expect(viewModel.withLoadMore, isFalse);
    });
  });

  test('items should transform OffreEmploi to OffreEmploiItemViewModel', () {
    // Given
    final store = givenState().successRechercheEmploiState(results: [mockOffreEmploi()]).store();

    // When
    final viewModel = _makeViewModel(store);

    // Then
    expect(viewModel.items, [mockOffreEmploi()]);
  });

  test('onLoadMore should dispatch proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = _makeViewModel(store);

    // When
    viewModel.onLoadMore();

    // Then
    expect(store.dispatchedAction, isA<RechercheLoadMoreAction<OffreEmploi>>());
  });
}

BlocResultatRechercheViewModel<OffreEmploi> _makeViewModel(Store<AppState> store) {
  return BlocResultatRechercheViewModel.create(store, (state) => state.rechercheEmploiState);
}
