import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_criteres_cherche_view_model.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('isOpen', () {
    test('when recherche status is nouvelle recherche should return true', () {
      // Given
      final store = givenState().initialRechercheEmploiState().store();

      // When
      final viewModel = BlocCriteresRechercheViewModel.create(store);

      // Then
      expect(viewModel.isOpen, isTrue);
    });

    test('when recherche status is initial loading should return true', () {
      // Given
      final store = givenState().initialLoadingRechercheEmploiState().store();

      // When
      final viewModel = BlocCriteresRechercheViewModel.create(store);

      // Then
      expect(viewModel.isOpen, isTrue);
    });

    test('when recherche status is failure should return true', () {
      // Given
      final store = givenState().failureRechercheEmploiState().store();

      // When
      final viewModel = BlocCriteresRechercheViewModel.create(store);

      // Then
      expect(viewModel.isOpen, isTrue);
    });

    test('when recherche status is success should return false', () {
      // Given
      final store = givenState().successRechercheEmploiState().store();

      // When
      final viewModel = BlocCriteresRechercheViewModel.create(store);

      // Then
      expect(viewModel.isOpen, isFalse);
    });

    test('when recherche status is update loading should return false', () {
      // Given
      final store = givenState().updateLoadingRechercheEmploiState().store();

      // When
      final viewModel = BlocCriteresRechercheViewModel.create(store);

      // Then
      expect(viewModel.isOpen, isFalse);
    });
  });

  group('onExpansionChanged', () {
    test('called with true should dispatch proper action', () {
      // Given
      final store = StoreSpy();
      final viewModel = BlocCriteresRechercheViewModel.create(store);

      // When
      viewModel.onExpansionChanged(true);

      // Then
      expect(store.dispatchedAction, isA<RechercheNewAction<OffreEmploi>>());
    });

    test('called with false should not dispatch action', () {
      // Given
      final store = StoreSpy();
      final viewModel = BlocCriteresRechercheViewModel.create(store);

      // When
      viewModel.onExpansionChanged(false);

      // Then
      expect(store.dispatchedAction, isNull);
    });
  });

  test('onSearchingRequest should dispatch proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = BlocCriteresRechercheViewModel.create(store);

    // When
    viewModel.onSearchingRequest('keywords', mockLocation(), false);

    // Then
    final dispatchedAction = store.dispatchedAction;
    expect(
      dispatchedAction,
      isA<RechercheRequestAction<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres>>(),
    );
    expect(
      (dispatchedAction as RechercheRequestAction<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres>).request,
      RechercheRequest(
        EmploiCriteresRecherche(keywords: 'keywords', location: mockLocation(), onlyAlternance: false),
        OffreEmploiSearchParametersFiltres.noFiltres(),
        1,
      ),
    );
  });
}
