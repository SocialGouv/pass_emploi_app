import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_modalite.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_type.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi/evenement_emploi_filtres_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("create when search state is success should display success", () {
    // Given
    final store = givenState().successRechercheEvenementEmploiState(results: [mockEvenementEmploi()]).store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test("create when search state is loading should display loading", () {
    // Given
    final store = givenState().updateLoadingRechercheEvenementEmploiState().store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("create when search state is failure should display failure", () {
    // Given
    final store = givenState().failureRechercheEvenementEmploiState().store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test(
      "create when search state is success but empty should display content (empty content is directly handled by result page)",
      () {
    // Given
    final store = givenState().successRechercheEvenementEmploiState(results: []).store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test("create when state has no filtre set should not pre-check any filtre", () {
    // Given
    final store = givenState()
        .successRechercheEvenementEmploiStateWithRequest(filtres: EvenementEmploiFiltresRecherche.noFiltre())
        .store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.typeFiltres, _allTypeInitiallyUnchecked());
    expect(viewModel.modalitesFiltres, _allModalitesInitiallyUnchecked());
    expect(viewModel.initialDateDebut, null);
    expect(viewModel.initialDateFin, null);
  });

  test("create when state has type filtre set should pre-check type", () {
    // Given
    final store = givenState()
        .successRechercheEvenementEmploiStateWithRequest(
          filtres: EvenementEmploiFiltresRecherche.withFiltres(type: EvenementEmploiType.reunionInformation),
        )
        .store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(
        viewModel.typeFiltres,
        _allTypeInitiallyUnchecked()
            .map(
              (checkbox) => CheckboxValueViewModel(
                label: checkbox.label,
                value: checkbox.value,
                isInitiallyChecked: checkbox.value == EvenementEmploiType.reunionInformation,
              ),
            )
            .toList());
  });

  test("create when state has modalité filtre set should pre-check type", () {
    // Given
    final store = givenState()
        .successRechercheEvenementEmploiStateWithRequest(
          filtres: EvenementEmploiFiltresRecherche.withFiltres(modalites: [EvenementEmploiModalite.enPhysique]),
        )
        .store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(
        viewModel.modalitesFiltres,
        _allModalitesInitiallyUnchecked()
            .map(
              (checkbox) => CheckboxValueViewModel(
                label: checkbox.label,
                value: checkbox.value,
                isInitiallyChecked: checkbox.value == EvenementEmploiModalite.enPhysique,
              ),
            )
            .toList());
  });

  test("create when state has dates set should pre-check dates", () {
    // Given
    final store = givenState()
        .successRechercheEvenementEmploiStateWithRequest(
          filtres: EvenementEmploiFiltresRecherche.withFiltres(
            dateDebut: DateTime(2030, 1, 1),
            dateFin: DateTime(2030, 1, 2),
          ),
        )
        .store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDateDebut, DateTime(2030, 1, 1));
    expect(viewModel.initialDateFin, DateTime(2030, 1, 2));
  });
}

List<CheckboxValueViewModel<EvenementEmploiModalite>> _allModalitesInitiallyUnchecked() {
  return [
    CheckboxValueViewModel(
      label: 'En présentiel',
      value: EvenementEmploiModalite.enPhysique,
      isInitiallyChecked: false,
    ),
    CheckboxValueViewModel(label: 'À distance', value: EvenementEmploiModalite.aDistance, isInitiallyChecked: false),
  ];
}

List<CheckboxValueViewModel<EvenementEmploiType?>> _allTypeInitiallyUnchecked() {
  return [
    CheckboxValueViewModel(label: 'Tous les types d\'événement', value: null, isInitiallyChecked: true),
    CheckboxValueViewModel(
      label: 'Réunion d\'information',
      value: EvenementEmploiType.reunionInformation,
      isInitiallyChecked: false,
    ),
    CheckboxValueViewModel(
      label: 'Forum',
      value: EvenementEmploiType.forum,
      isInitiallyChecked: false,
    ),
    CheckboxValueViewModel(
      label: 'Conférence',
      value: EvenementEmploiType.conference,
      isInitiallyChecked: false,
    ),
    CheckboxValueViewModel(
      label: 'Atelier',
      value: EvenementEmploiType.atelier,
      isInitiallyChecked: false,
    ),
    CheckboxValueViewModel(
      label: 'Salon en ligne',
      value: EvenementEmploiType.salonEnLigne,
      isInitiallyChecked: false,
    ),
    CheckboxValueViewModel(
      label: 'Job Dating',
      value: EvenementEmploiType.jobDating,
      isInitiallyChecked: false,
    ),
    CheckboxValueViewModel(
      label: 'Visite d\'entreprise',
      value: EvenementEmploiType.visiteEntreprise,
      isInitiallyChecked: false,
    ),
    CheckboxValueViewModel(
      label: 'Portes ouvertes',
      value: EvenementEmploiType.portesOuvertes,
      isInitiallyChecked: false,
    ),
  ];
}
