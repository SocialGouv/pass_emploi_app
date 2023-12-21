import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("create when search state is success should display success", () {
    // Given
    final store = givenState().successRechercheEmploiState(results: [mockOffreEmploi()]).store();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.contenu);
  });

  test("create when search state is loading should display loading", () {
    // Given
    final store = givenState().updateLoadingRechercheEmploiState().store();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.chargement);
  });

  test("create when search state is failure should display failure", () {
    // Given
    final store = givenState().failureRechercheEmploiState().store();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.erreur);
  });

  test(
      "create when search state is success but empty should display content (empty content is directly handled by result page)",
      () {
    // Given
        final store = givenState().successRechercheEmploiState(results: []).store();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.contenu);
  });

  test("create when state has no filtre should set distance to 10km", () {
    // Given
    final store = givenState()
        .successRechercheEmploiStateWithRequest(
          criteres: EmploiCriteresRecherche(
            location: mockCommuneLocation(),
            keyword: '',
            rechercheType: RechercheType.onlyAlternance,
          ),
        )
        .store();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 10);
  });

  test("create when state distance filtre set should set distance", () {
    // Given
    final store = givenState()
        .successRechercheEmploiStateWithRequest(
          criteres: EmploiCriteresRecherche(
            keyword: '',
            location: mockCommuneLocation(),
            rechercheType: RechercheType.offreEmploiAndAlternance,
          ),
          filtres: EmploiFiltresRecherche.withFiltres(distance: 20),
        )
        .store();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 20);
  });

  test("create when search location is a departement should not display distance filtre", () {
    // Given
    final store = givenState()
        .successRechercheEmploiStateWithRequest(
          criteres: EmploiCriteresRecherche(
            keyword: '',
            location: mockLocation(),
            rechercheType: RechercheType.offreEmploiAndAlternance,
          ),
        )
        .store();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, isFalse);
  });

  test("create when search location is a commune should display distance filtre", () {
    // Given
    final store = givenState()
        .successRechercheEmploiStateWithRequest(
          criteres: EmploiCriteresRecherche(
            keyword: '',
            location: mockCommuneLocation(),
            rechercheType: RechercheType.offreEmploiAndAlternance,
          ),
          filtres: EmploiFiltresRecherche.withFiltres(distance: 20),
        )
        .store();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, isTrue);
  });

  test('create when search location is not only alternance should display non distance filtres', () {
    // Given
    final store = _store(rechercheType: RechercheType.offreEmploiAndAlternance);

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayNonDistanceFiltres, isTrue);
  });

  test('create when search location is only alternance should not display non distance filtres', () {
    // Given
    final store = _store(rechercheType: RechercheType.onlyAlternance);

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayNonDistanceFiltres, isFalse);
  });

  test("create when state has no filtre set should not pre-check any filtre", () {
    // Given
    final store =
        givenState().successRechercheEmploiStateWithRequest(filtres: EmploiFiltresRecherche.noFiltre()).store();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDebutantOnlyFiltre, null);
    expect(viewModel.contratFiltres, _allContratsInitiallyUnchecked());
    expect(viewModel.dureeFiltres, _allDureesInitiallyUnchecked());
  });

  test("create when state has all checkboxes filtres selected should pre-check every filtres", () {
    // Given
    final store = givenState()
        .successRechercheEmploiStateWithRequest(
          filtres: EmploiFiltresRecherche.withFiltres(
            debutantOnly: true,
            experience: [
              ExperienceFiltre.de_zero_a_un_an,
              ExperienceFiltre.de_un_a_trois_ans,
              ExperienceFiltre.trois_ans_et_plus
            ],
            contrat: [ContratFiltre.cdi, ContratFiltre.cdd_interim_saisonnier, ContratFiltre.autre],
            duree: [DureeFiltre.temps_plein, DureeFiltre.temps_partiel],
          ),
        )
        .store();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDebutantOnlyFiltre, true);

    expect(
      viewModel.contratFiltres,
      _allContratsInitiallyUnchecked()
          .map((e) =>
              CheckboxValueViewModel(label: e.label, helpText: e.helpText, value: e.value, isInitiallyChecked: true))
          .toList(),
    );

    expect(
      viewModel.dureeFiltres,
      _allDureesInitiallyUnchecked()
          .map((e) =>
              CheckboxValueViewModel(label: e.label, helpText: e.helpText, value: e.value, isInitiallyChecked: true))
          .toList(),
    );
  });

  test("updateFiltres should map view model input into action", () {
    // Given
    final store = StoreSpy();
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // When
    viewModel.updateFiltres(
      20,
      true,
      _allContratsInitiallyUnchecked(),
      _allDureesInitiallyUnchecked(),
    );

    // Then
    final action = store.dispatchedAction as RechercheUpdateFiltresAction<EmploiFiltresRecherche>;
    expect(action.filtres.distance, 20);
    expect(action.filtres.debutantOnly, true);
    expect(action.filtres.contrat, [
      ContratFiltre.cdi,
      ContratFiltre.cdd_interim_saisonnier,
      ContratFiltre.autre,
    ]);
    expect(action.filtres.duree, [
      DureeFiltre.temps_plein,
      DureeFiltre.temps_partiel,
    ]);
  });
}

List<CheckboxValueViewModel<DureeFiltre>> _allDureesInitiallyUnchecked() {
  return [
    CheckboxValueViewModel(label: "Temps plein", value: DureeFiltre.temps_plein, isInitiallyChecked: false),
    CheckboxValueViewModel(label: "Temps partiel", value: DureeFiltre.temps_partiel, isInitiallyChecked: false),
  ];
}

List<CheckboxValueViewModel<ContratFiltre>> _allContratsInitiallyUnchecked() {
  return [
    CheckboxValueViewModel(
        label: "CDI", helpText: "CDI et CDI Intérimaire", value: ContratFiltre.cdi, isInitiallyChecked: false),
    CheckboxValueViewModel(
      label: "CDD - intérim - saisonnier",
      value: ContratFiltre.cdd_interim_saisonnier,
      isInitiallyChecked: false,
    ),
    CheckboxValueViewModel(
      label: "Autres",
      helpText:
          "Profession commerciale, Franchise, Profession libérale, Reprise d’entreprise, Contrat travail temporaire insertion",
      value: ContratFiltre.autre,
      isInitiallyChecked: false,
    ),
  ];
}

Store<AppState> _store({required RechercheType rechercheType}) {
  return givenState()
      .successRechercheEmploiStateWithRequest(
        criteres: EmploiCriteresRecherche(keyword: '', location: mockCommuneLocation(), rechercheType: rechercheType),
      )
      .store();
}
