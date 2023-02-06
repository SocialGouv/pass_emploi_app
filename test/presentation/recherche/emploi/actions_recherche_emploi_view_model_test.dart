import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/recherche/emploi/actions_recherche_emploi_view_model.dart';

import '../../../doubles/fixtures.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  group('withAlertButton', () {
    test('when recherche status is nouvelle recherche should return false', () {
      // Given
      final store = givenState().initialRechercheEmploiState().store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isFalse);
    });

    test('when recherche status is failure should return false', () {
      // Given
      final store = givenState().failureRechercheEmploiState().store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isFalse);
    });

    test('when recherche status is success should return true', () {
      // Given
      final store = givenState().successRechercheEmploiState().store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isTrue);
    });

    test('when recherche status is update loading should return true', () {
      // Given
      final store = givenState().updateLoadingRechercheEmploiState().store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.withAlertButton, isTrue);
    });
  });

  group('withFiltreButton', () {
    test('when recherche status is nouvelle recherche should return false', () {
      // Given
      final store = givenState().initialRechercheEmploiState().store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isFalse);
    });

    test('when recherche status is failure should return false', () {
      // Given
      final store = givenState().failureRechercheEmploiState().store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isFalse);
    });

    test('when recherche status is success should return true', () {
      // Given
      final store = givenState().successRechercheEmploiState().store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isTrue);
    });

    test('when recherche status is update loading should return true', () {
      // Given
      final store = givenState().updateLoadingRechercheEmploiState().store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, isTrue);
    });

    group('when recherche status is success and request is only alterance', () {
      test('if location is null should return false', () {
        // Given
        final store = givenState()
            .successRechercheEmploiStateWithRequest(
              criteres: EmploiCriteresRecherche(location: null, keywords: '', onlyAlternance: true),
            )
            .store();

        // When
        final viewModel = ActionsRechercheEmploiViewModel.create(store);

        // Then
        expect(viewModel.withFiltreButton, isFalse);
      });

      test('if location is not of type COMMUNE return false', () {
        // Given
        final store = givenState()
            .successRechercheEmploiStateWithRequest(
              criteres: EmploiCriteresRecherche(location: mockLocation(), keywords: '', onlyAlternance: true),
            )
            .store();

        // When
        final viewModel = ActionsRechercheEmploiViewModel.create(store);

        // Then
        expect(viewModel.withFiltreButton, isFalse);
      });

      test('if location is of type COMMUNE return true', () {
        // Given
        final store = givenState()
            .successRechercheEmploiStateWithRequest(
              criteres: EmploiCriteresRecherche(location: mockCommuneLocation(), keywords: '', onlyAlternance: true),
            )
            .store();

        // When
        final viewModel = ActionsRechercheEmploiViewModel.create(store);

        // Then
        expect(viewModel.withFiltreButton, isTrue);
      });
    });
  });

  group('filtresCount', () {
    test('when state has no active filtre it should not display a filtre number', () {
      // Given
      final store = givenState()
          .successRechercheEmploiStateWithRequest(filtres: OffreEmploiSearchParametersFiltres.noFiltres())
          .store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test('when state has active distance filtre it should display 1 as filtre number', () {
      // Given
      final store = givenState()
          .successRechercheEmploiStateWithRequest(filtres: OffreEmploiSearchParametersFiltres.withFiltres(distance: 40))
          .store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 1);
    });

    test('when state has active distance filtre but value is default it should not display a filtre number', () {
      // Given
      final store = givenState()
          .successRechercheEmploiStateWithRequest(filtres: OffreEmploiSearchParametersFiltres.withFiltres(distance: 10))
          .store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test('when state has active experience filtre it should display 1 as filtre number', () {
      // Given
      final store = givenState()
          .successRechercheEmploiStateWithRequest(
            filtres: OffreEmploiSearchParametersFiltres.withFiltres(experience: [ExperienceFiltre.trois_ans_et_plus]),
          )
          .store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 1);
    });

    test('when state has 2 active experience filtres it should display 2 as filtre number', () {
      // Given
      final store = givenState()
          .successRechercheEmploiStateWithRequest(
            filtres: OffreEmploiSearchParametersFiltres.withFiltres(
              experience: [ExperienceFiltre.de_un_a_trois_ans, ExperienceFiltre.trois_ans_et_plus],
            ),
          )
          .store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 2);
    });

    test('when state has empty experience filtre it should not display a filtre number', () {
      // Given
      final store = givenState()
          .successRechercheEmploiStateWithRequest(
            filtres: OffreEmploiSearchParametersFiltres.withFiltres(experience: []),
          )
          .store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test('when state has active contrat filtre it should display 1 as filtre number', () {
      // Given
      final store = givenState()
          .successRechercheEmploiStateWithRequest(
            filtres: OffreEmploiSearchParametersFiltres.withFiltres(contrat: [ContratFiltre.autre]),
          )
          .store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 1);
    });

    test('when state has 3 active contrat filtres it should display 3 as filtre number', () {
      // Given
      final store = givenState()
          .successRechercheEmploiStateWithRequest(
            filtres: OffreEmploiSearchParametersFiltres.withFiltres(contrat: [
              ContratFiltre.autre,
              ContratFiltre.cdd_interim_saisonnier,
              ContratFiltre.cdi,
            ]),
          )
          .store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 3);
    });

    test('when state has active duree filtre it should display 1 as filtre number', () {
      // Given
      final store = givenState()
          .successRechercheEmploiStateWithRequest(
            filtres: OffreEmploiSearchParametersFiltres.withFiltres(duree: [DureeFiltre.temps_plein]),
          )
          .store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 1);
    });

    test('when state has multiple active duree filtres it should display 2 as filtre number', () {
      // Given
      final store = givenState()
          .successRechercheEmploiStateWithRequest(
            filtres: OffreEmploiSearchParametersFiltres.withFiltres(
              duree: [DureeFiltre.temps_plein, DureeFiltre.temps_partiel],
            ),
          )
          .store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 2);
    });

    test(
        'when state has all active filtres at the same time it should display the total count of active filtre as filtre number',
        () {
      // Given
      final store = givenState()
          .successRechercheEmploiStateWithRequest(
            filtres: OffreEmploiSearchParametersFiltres.withFiltres(
              distance: 40,
              debutantOnly: true,
              contrat: [
                ContratFiltre.cdi,
                ContratFiltre.cdd_interim_saisonnier,
                ContratFiltre.autre,
              ],
              experience: [
                ExperienceFiltre.trois_ans_et_plus,
                ExperienceFiltre.de_un_a_trois_ans,
                ExperienceFiltre.de_zero_a_un_an,
              ],
              duree: [
                DureeFiltre.temps_plein,
                DureeFiltre.temps_partiel,
              ],
            ),
          )
          .store();

      // When
      final viewModel = ActionsRechercheEmploiViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 10);
    });
  });
}
