import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_modalite.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_type.dart';
import 'package:pass_emploi_app/presentation/recherche/evenement_emploi/actions_recherche_evenement_emploi_view_model.dart';

import '../../../dsl/app_state_dsl.dart';

void main() {
  group('withAlertButton', () {
    test('regardless of state should return false', () {
      // Given
      final store = givenState().successRechercheEvenementEmploiState().store();

      // When
      final viewModel = ActionsRechercheEvenementEmploiViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isFalse);
    });
  });

  group('withFiltreButton', () {
    test('when recherche status is nouvelle recherche should return false', () {
      // Given
      final store = givenState().initialLoadingRechercheEvenementEmploiState().store();

      // When
      final viewModel = ActionsRechercheEvenementEmploiViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isFalse);
    });

    test('when recherche status is failure should return false', () {
      // Given
      final store = givenState().failureRechercheEvenementEmploiState().store();

      // When
      final viewModel = ActionsRechercheEvenementEmploiViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isFalse);
    });

    test('when recherche status is success should return true', () {
      // Given
      final store = givenState().successRechercheEvenementEmploiState().store();

      // When
      final viewModel = ActionsRechercheEvenementEmploiViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isTrue);
    });

    test('when recherche status is update loading should return true', () {
      // Given
      final store = givenState().updateLoadingRechercheEvenementEmploiState().store();

      // When
      final viewModel = ActionsRechercheEvenementEmploiViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isTrue);
    });

    test('when recherche status is success and result is empty should hide filtre button', () {
      // Given
      final store = givenState().successRechercheEvenementEmploiState(results: []).store();

      // When
      final viewModel = ActionsRechercheEvenementEmploiViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isFalse);
    });
  });

  group('filtresCount', () {
    test('when state has no active filtre it should not display a filtre number', () {
      // Given
      final store = givenState() //
          .successRechercheEvenementEmploiStateWithRequest(filtres: EvenementEmploiFiltresRecherche.noFiltre())
          .store();

      // When
      final viewModel = ActionsRechercheEvenementEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test(
        'when state has all active filtres at the same time it should display the total count of active filtre as filtre number',
        () {
      // Given
      final store = givenState() //
          .successRechercheEvenementEmploiStateWithRequest(
            filtres: EvenementEmploiFiltresRecherche.withFiltres(
              type: EvenementEmploiType.conference,
              modalites: [EvenementEmploiModalite.aDistance],
              dateDebut: DateTime.now(),
              dateFin: DateTime.now(),
            ),
          )
          .store();

      // When
      final viewModel = ActionsRechercheEvenementEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 4);
    });
  });
}
