import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

main() {
  test("create when search state is success should display success", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.success(),
        offreEmploiSearchResultsState:
            OffreEmploiSearchResultsState.data(offres: [mockOffreEmploi()], loadedPage: 1, isMoreDataAvailable: true),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test("create when search state is loading should display loading", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.loading(),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("create when search state is failure should display failure", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.failure(),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });

  test(
      "create when search state is success but empty should display content (empty content is directly handled by result page)",
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
          offreEmploiSearchState: OffreEmploiSearchState.success(),
          offreEmploiSearchResultsState:
              OffreEmploiSearchResultsState.data(offres: [], loadedPage: 1, isMoreDataAvailable: false)),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.errorMessage, '');
  });

  test("create when state has no filtre should set distance to 10km", () {
    // Given
    final store = _storeWithCommuneSearchAndNoFiltres();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 10);
  });

  test("create when state distance filtre set should set distance", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
          keywords: "mots clés",
          location: mockCommuneLocation(),
          onlyAlternance: false,
          filtres: OffreEmploiSearchParametersFiltres.withFiltres(distance: 20),
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 20);
  });

  test("create when search location is a departement should not display distance filtre", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
          keywords: "mots clés",
          location: mockLocation(),
          onlyAlternance: false,
          filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, isFalse);
  });

  test("create when search location is a commune should display distance filtre", () {
    // Given
    final store = _storeWithCommuneSearchAndNoFiltres();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, isTrue);
  });

  test('create when search location is not only alternance should display non distance filtres', () {
    // Given
    final store = _store(alternanceOnly: false);

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayNonDistanceFiltres, isTrue);
  });

  test('create when search location is only alternance should not display non distance filtres', () {
    // Given
    final store = _store(alternanceOnly: true);

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayNonDistanceFiltres, isFalse);
  });

  test("create when state has no filtre set should not pre-check any filtre", () {
    // Given
    final store = _storeWithCommuneSearchAndNoFiltres();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.experienceFiltres, _allExperiencesInitiallyUnchecked());

    expect(viewModel.contratFiltres, _allContratsInitiallyUnchecked());

    expect(viewModel.dureeFiltres, _allDureesInitiallyUnchecked());
  });

  test("create when state has all checkboxes filtres selected should pre-check every filtres", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
          keywords: "mots clés",
          location: mockCommuneLocation(),
          onlyAlternance: false,
          filtres: OffreEmploiSearchParametersFiltres.withFiltres(
            experience: [
              ExperienceFiltre.de_zero_a_un_an,
              ExperienceFiltre.de_un_a_trois_ans,
              ExperienceFiltre.trois_ans_et_plus
            ],
            contrat: [ContratFiltre.cdi, ContratFiltre.cdd_interim_saisonnier, ContratFiltre.autre],
            duree: [DureeFiltre.temps_plein, DureeFiltre.temps_partiel],
          ),
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(
        viewModel.experienceFiltres,
        _allExperiencesInitiallyUnchecked()
            .map((e) =>
                CheckboxValueViewModel(label: e.label, helpText: e.helpText, value: e.value, isInitiallyChecked: true))
            .toList());

    expect(
        viewModel.contratFiltres,
        _allContratsInitiallyUnchecked()
            .map((e) =>
                CheckboxValueViewModel(label: e.label, helpText: e.helpText, value: e.value, isInitiallyChecked: true))
            .toList());

    expect(
        viewModel.dureeFiltres,
        _allDureesInitiallyUnchecked()
            .map((e) =>
                CheckboxValueViewModel(label: e.label, helpText: e.helpText, value: e.value, isInitiallyChecked: true))
            .toList());
  });

  test("updateFiltres should map view model input into action", () {
    // Given
    final store = StoreSpy();

    final viewModel = OffreEmploiFiltresViewModel.create(store);
    // When

    viewModel.updateFiltres(
      20,
      _allExperiencesInitiallyUnchecked(),
      _allContratsInitiallyUnchecked(),
      _allDureesInitiallyUnchecked(),
    );

    // Then
    final OffreEmploiSearchUpdateFiltresAction action = store.dispatchedAction as OffreEmploiSearchUpdateFiltresAction;
    expect(action.updatedFiltres.distance, 20);
    expect(action.updatedFiltres.contrat, [
      ContratFiltre.cdi,
      ContratFiltre.cdd_interim_saisonnier,
      ContratFiltre.autre,
    ]);
    expect(action.updatedFiltres.experience, [
      ExperienceFiltre.de_zero_a_un_an,
      ExperienceFiltre.de_un_a_trois_ans,
      ExperienceFiltre.trois_ans_et_plus,
    ]);
    expect(action.updatedFiltres.duree, [
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

List<CheckboxValueViewModel<ExperienceFiltre>> _allExperiencesInitiallyUnchecked() {
  return [
    CheckboxValueViewModel(label: "De 0 à 1 an", value: ExperienceFiltre.de_zero_a_un_an, isInitiallyChecked: false),
    CheckboxValueViewModel(
        label: "De 1 an à 3 ans", value: ExperienceFiltre.de_un_a_trois_ans, isInitiallyChecked: false),
    CheckboxValueViewModel(label: "3 ans et +", value: ExperienceFiltre.trois_ans_et_plus, isInitiallyChecked: false),
  ];
}

Store<AppState> _storeWithCommuneSearchAndNoFiltres({customReducer = reducer}) {
  return Store<AppState>(
    customReducer,
    initialState: AppState.initialState().copyWith(
      offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
        keywords: "mots clés",
        location: mockCommuneLocation(),
        onlyAlternance: false,
        filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
    ),
  );
}

Store<AppState> _store({required bool alternanceOnly}) {
  return Store<AppState>(
    reducer,
    initialState: AppState.initialState().copyWith(
      offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
        keywords: "",
        location: null,
        onlyAlternance: alternanceOnly,
        filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
    ),
  );
}
