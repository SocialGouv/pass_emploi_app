import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/recherche/immersion/actions_recherche_immersion_view_model.dart';

import '../../../dsl/app_state_dsl.dart';

void main() {
  group('withAlertButton', () {
    test('when recherche status is nouvelle recherche should return false', () {
      // Given
      final store = givenState().initialRechercheImmersionState().store();

      // When
      final viewModel = ActionsRechercheImmersionViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isFalse);
    });

    test('when recherche status is failure should return false', () {
      // Given
      final store = givenState().failureRechercheImmersionState().store();

      // When
      final viewModel = ActionsRechercheImmersionViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isFalse);
    });

    test('when recherche status is success should return true', () {
      // Given
      final store = givenState().successRechercheImmersionState().store();

      // When
      final viewModel = ActionsRechercheImmersionViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isTrue);
    });

    test('when recherche status is update loading should return true', () {
      // Given
      final store = givenState().updateLoadingRechercheImmersionState().store();

      // When
      final viewModel = ActionsRechercheImmersionViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isTrue);
    });
  });

  group('withFiltreButton', () {
    test('when recherche status is nouvelle recherche should return false', () {
      // Given
      final store = givenState().initialRechercheImmersionState().store();

      // When
      final viewModel = ActionsRechercheImmersionViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isFalse);
    });

    test('when recherche status is failure should return false', () {
      // Given
      final store = givenState().failureRechercheImmersionState().store();

      // When
      final viewModel = ActionsRechercheImmersionViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isFalse);
    });

    test('when recherche status is success should return true', () {
      // Given
      final store = givenState().successRechercheImmersionState().store();

      // When
      final viewModel = ActionsRechercheImmersionViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isTrue);
    });

    test('when recherche status is update loading should return true', () {
      // Given
      final store = givenState().updateLoadingRechercheImmersionState().store();

      // When
      final viewModel = ActionsRechercheImmersionViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isTrue);
    });
  });

  group('filtresCount', () {
    test('when state has no active filtre it should not display a filtre number', () {
      // Given
      final store = givenState()
          .successRechercheImmersionStateWithRequest(filtres: ImmersionSearchParametersFiltres.noFiltres())
          .store();

      // When
      final viewModel = ActionsRechercheImmersionViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test(
        'when state has all active filtres at the same time it should display the total count of active filtre as filtre number',
        () {
      // Given
      final store = givenState()
          .successRechercheImmersionStateWithRequest(
            filtres: ImmersionSearchParametersFiltres.distance(50),
          )
          .store();

      // When
      final viewModel = ActionsRechercheImmersionViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 1);
    });
  });
}
