import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/presentation/recherche/service_civique/actions_recherche_service_civique_view_model.dart';

import '../../../dsl/app_state_dsl.dart';

void main() {
  group('withAlertButton', () {
    test('when recherche status is nouvelle recherche should return false', () {
      // Given
      final store = givenState().initialRechercheServiceCiviqueState().store();

      // When
      final viewModel = ActionsRechercheServiceCiviqueViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isFalse);
    });

    test('when recherche status is failure should return false', () {
      // Given
      final store = givenState().failureRechercheServiceCiviqueState().store();

      // When
      final viewModel = ActionsRechercheServiceCiviqueViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isFalse);
    });

    test('when recherche status is success should return true', () {
      // Given
      final store = givenState().successRechercheServiceCiviqueState().store();

      // When
      final viewModel = ActionsRechercheServiceCiviqueViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isTrue);
    });

    test('when recherche status is update loading should return true', () {
      // Given
      final store = givenState().updateLoadingRechercheServiceCiviqueState().store();

      // When
      final viewModel = ActionsRechercheServiceCiviqueViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isTrue);
    });
  });

  group('withFiltreButton', () {
    test('when recherche status is nouvelle recherche should return false', () {
      // Given
      final store = givenState().initialRechercheServiceCiviqueState().store();

      // When
      final viewModel = ActionsRechercheServiceCiviqueViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isFalse);
    });

    test('when recherche status is failure should return false', () {
      // Given
      final store = givenState().failureRechercheServiceCiviqueState().store();

      // When
      final viewModel = ActionsRechercheServiceCiviqueViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isFalse);
    });

    test('when recherche status is success should return true', () {
      // Given
      final store = givenState().successRechercheServiceCiviqueState().store();

      // When
      final viewModel = ActionsRechercheServiceCiviqueViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isTrue);
    });

    test('when recherche status is update loading should return true', () {
      // Given
      final store = givenState().updateLoadingRechercheServiceCiviqueState().store();

      // When
      final viewModel = ActionsRechercheServiceCiviqueViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isTrue);
    });

    test('when recherche status is success and result is empty should return true', () {
      // Given
      final store = givenState().successRechercheServiceCiviqueState(results: []).store();

      // When
      final viewModel = ActionsRechercheServiceCiviqueViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isFalse);
    });
  });

  group('filtresCount', () {
    test('when state has no active filtre it should not display a filtre number', () {
      // Given
      final store = givenState()
          .successRechercheServiceCiviqueStateWithRequest(filtres: ServiceCiviqueFiltresRecherche.noFiltre())
          .store();

      // When
      final viewModel = ActionsRechercheServiceCiviqueViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test(
        'when state has all active filtres at the same time it should display the total count of active filtre as filtre number',
        () {
      // Given
      final store = givenState()
          .successRechercheServiceCiviqueStateWithRequest(
            filtres: ServiceCiviqueFiltresRecherche(
              distance: 20,
              startDate: DateTime(2023),
              domain: Domaine.fromTag("sport"),
            ),
          )
          .store();

      // When
      final viewModel = ActionsRechercheServiceCiviqueViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 3);
    });
  });
}
