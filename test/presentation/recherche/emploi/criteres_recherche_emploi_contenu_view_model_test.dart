import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/emploi/criteres_recherche_emploi_contenu_view_model.dart';

import '../../../doubles/fixtures.dart';
import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  group('displayState', () {
    test('when recherche status is nouvelle recherche should display CONTENT', () {
      // Given
      final store = givenState().initialRechercheEmploiState().store();

      // When
      final viewModel = CriteresRechercheEmploiContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('when recherche status is initial loading should display LOADING', () {
      // Given
      final store = givenState().initialLoadingRechercheEmploiState().store();

      // When
      final viewModel = CriteresRechercheEmploiContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when recherche status is failure should display FAILURE', () {
      // Given
      final store = givenState().failureRechercheEmploiState().store();

      // When
      final viewModel = CriteresRechercheEmploiContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });
  });

  test('onSearchingRequest should dispatch proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = CriteresRechercheEmploiContenuViewModel.create(store);

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
