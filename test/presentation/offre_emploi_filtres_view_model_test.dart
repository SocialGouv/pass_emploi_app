import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
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

  test("create when search state is failure should display success", () {
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
  });

  test("create when state has no filter should set distance to 10km", () {
    // Given
    final store = _mockStoreWithCommuneSearchAndNoFiltres();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 10);
  });

  test("create when state distance filter set should set distance", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
          "mots clés",
          mockCommuneLocation(),
          OffreEmploiSearchParametersFiltres.withFiltres(distance: 20),
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 20);
  });

  test("create when search location is a departement should not display distance filter", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
          "mots clés",
          mockLocation(),
          OffreEmploiSearchParametersFiltres.noFiltres(),
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, isFalse);
  });

  test("create when search location is a commune should display distance filter", () {
    // Given
    final store = _mockStoreWithCommuneSearchAndNoFiltres();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, isTrue);
  });

  test("create when state has no filtre set should not pre-check any filtre", () {
    // Given
    final store = _mockStoreWithCommuneSearchAndNoFiltres();

    // When
    final viewModel = OffreEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.experienceFiltres, _allExperiencesInitiallyUnchecked());

    expect(viewModel.contratFiltres, _allContratsInitiallyUnchecked());

    expect(viewModel.dureeFiltres, _allDureesInitiallyUnchecked());
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
    CheckboxValueViewModel(label: "CDI", value: ContratFiltre.cdi, isInitiallyChecked: false),
    CheckboxValueViewModel(
      label: "CDD - intérim - saisonnier",
      value: ContratFiltre.cdd_interim_saisonnier,
      isInitiallyChecked: false,
    ),
    CheckboxValueViewModel(label: "Autres", value: ContratFiltre.autre, isInitiallyChecked: false),
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

Store<AppState> _mockStoreWithCommuneSearchAndNoFiltres({customReducer = reducer}) {
  return Store<AppState>(
    customReducer,
    initialState: AppState.initialState().copyWith(
      offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
        "mots clés",
        mockCommuneLocation(),
        OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
    ),
  );
}
