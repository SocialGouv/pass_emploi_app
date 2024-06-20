import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/thematiques_demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('ThematiqueDemarchePageViewModel', () {
    group('displayState', () {
      test('when thematiques demarche state is not initialized should return initial', () {
        // Given
        final store = givenState().loggedIn().store();

        // When
        final viewModel = ThematiqueDemarchePageViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('when thematiques demarche state is loading should display loading', () {
        // Given
        final store = givenState().loggedIn().withThematiqueDemarcheLoadingState().store();

        // When
        final viewModel = ThematiqueDemarchePageViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('when thematiques demarche state is failure should display failure', () {
        // Given
        final store = givenState().loggedIn().withThematiqueDemarcheFailureState().store();

        // When
        final viewModel = ThematiqueDemarchePageViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.FAILURE);
      });

      test('when thematiques demarche state is success should display thematic list', () {
        // Given
        final store = givenState().loggedIn().withThematiqueDemarcheSuccessState().store();

        // When
        final viewModel = ThematiqueDemarchePageViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
      });
    });

    group('thematiques', () {
      test('when thematiques demarche state is not success should return empty list', () {
        // Given
        final store = givenState().loggedIn().store();

        // When
        final viewModel = ThematiqueDemarchePageViewModel.create(store);

        // Then
        expect(viewModel.thematiques, []);
      });

      test('when thematiques demarche state is success should return thematic list', () {
        // Given
        final store = givenState().loggedIn().withThematiqueDemarcheSuccessState().store();

        // When
        final viewModel = ThematiqueDemarchePageViewModel.create(store);

        // Then
        expect(viewModel.thematiques.length, 1);
        final thematique = viewModel.thematiques.first;
        expect(thematique.id, "P03");
        expect(thematique.title, "Mes candidatures");
      });
    });

    group('onRetry', () {
      test('should retry', () {
        // Given
        final store = StoreSpy();
        final viewModel = ThematiqueDemarchePageViewModel.create(store);

        // When
        viewModel.onRetry();

        // Then
        expect(store.dispatchedAction, isA<ThematiqueDemarcheRequestAction>());
      });
    });
  });
}
