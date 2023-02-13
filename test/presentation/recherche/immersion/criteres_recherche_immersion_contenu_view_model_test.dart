import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/immersion/criteres_recherche_immersion_contenu_view_model.dart';

import '../../../doubles/fixtures.dart';
import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  group('displayState', () {
    test('when recherche status is nouvelle recherche should display CONTENT', () {
      // Given
      final store = givenState().initialRechercheImmersionState().store();

      // When
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('when recherche status is initial loading should display LOADING', () {
      // Given
      final store = givenState().initialLoadingRechercheImmersionState().store();

      // When
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when recherche status is failure should display FAILURE', () {
      // Given
      final store = givenState().failureRechercheImmersionState().store();

      // When
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });
  });

  test('onSearchingRequest should dispatch proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

    // When
    viewModel.onSearchingRequest(mockMetier(), mockLocation());

    // Then
    final dispatchedAction = store.dispatchedAction;
    expect(
      dispatchedAction,
      isA<RechercheRequestAction<ImmersionCriteresRecherche, ImmersionSearchParametersFiltres>>(),
    );
    expect(
      (dispatchedAction as RechercheRequestAction<ImmersionCriteresRecherche, ImmersionSearchParametersFiltres>)
          .request,
      RechercheRequest(
        ImmersionCriteresRecherche(metier: mockMetier(), location: mockLocation()),
        ImmersionSearchParametersFiltres.noFiltres(),
        1,
      ),
    );
  });
}
