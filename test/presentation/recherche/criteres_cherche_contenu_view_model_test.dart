import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/criteres_cherche_contenu_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  group('displayState', () {
    test('when recherche status is nouvelle recherche should display CONTENT', () {
      // Given
      final store = givenState().initialRechercheEmploiState().store();

      // When
      final viewModel = CriteresRechercheContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('when recherche status is initial loading should display LOADING', () {
      // Given
      final store = givenState().initialLoadingRechercheEmploiState().store();

      // When
      final viewModel = CriteresRechercheContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when recherche status is failure should display FAILURE', () {
      // Given
      final store = givenState().failureRechercheEmploiState().store();

      // When
      final viewModel = CriteresRechercheContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });
  });
}
