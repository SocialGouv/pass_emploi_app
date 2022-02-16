import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_list_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

main() {
  final _savedSearchs = [
    ImmersionSavedSearch(
        id: "id", title: "titreImmersion1", metier: "metierImmersion1", location: "ville", filters: null),
    ImmersionSavedSearch(
        id: "id", title: "titreImmersion2", metier: "metierImmersion2", location: "ville", filters: null),
    OffreEmploiSavedSearch(
      id: "id",
      title: "titreOffreEmploi1",
      metier: "metierOffreEmploi1",
      location: mockLocation(),
      keywords: "keywords",
      isAlternance: false,
      filters: OffreEmploiSearchParametersFiltres.noFiltres(),
    ),
    OffreEmploiSavedSearch(
      title: "titreOffreEmploi2",
      id: "id",
      metier: "metierOffreEmploi2",
      location: mockLocation(),
      keywords: "keywords",
      isAlternance: false,
      filters: OffreEmploiSearchParametersFiltres.noFiltres(),
    ),
    OffreEmploiSavedSearch(
      id: "id",
      title: "titreAlternance1",
      metier: "metierAlternance1",
      location: mockLocation(),
      keywords: "keywords",
      isAlternance: true,
      filters: OffreEmploiSearchParametersFiltres.noFiltres(),
    ),
    OffreEmploiSavedSearch(
      id: "id",
      title: "titreAlternance2",
      metier: "metierAlternance2",
      location: mockLocation(),
      keywords: "keywords",
      isAlternance: true,
      filters: OffreEmploiSearchParametersFiltres.noFiltres(),
    ),
  ];

  test("create should set loading properly", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: State<List>.loading(),
      ),
    );

    // When
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("create should set failure properly", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: State<List>.failure(),
      ),
    );

    // When
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test("create with success should load immersion list", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: State<List>.success(_savedSearchs),
      ),
    );

    // When
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.getImmersions(), [
      ImmersionSavedSearch(
          id: "id", title: "titreImmersion1", metier: "metierImmersion1", location: "ville", filters: null),
      ImmersionSavedSearch(
          id: "id", title: "titreImmersion2", metier: "metierImmersion2", location: "ville", filters: null),
    ]);
  });

  test("create with success should load offre emploi list", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: State<List>.success(_savedSearchs),
      ),
    );

    // When
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.getOffresEmploi(false), [
      OffreEmploiSavedSearch(
        id: "id",
        title: "titreOffreEmploi1",
        metier: "metierOffreEmploi1",
        location: mockLocation(),
        keywords: "keywords",
        isAlternance: false,
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
      OffreEmploiSavedSearch(
        id: "id",
        title: "titreOffreEmploi2",
        metier: "metierOffreEmploi2",
        location: mockLocation(),
        keywords: "keywords",
        isAlternance: false,
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
    ]);
  });

  test("create with success should load alternance list", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: State<List>.success(_savedSearchs),
      ),
    );

    // When
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.getOffresEmploi(true), [
      OffreEmploiSavedSearch(
        id: "id",
        title: "titreAlternance1",
        metier: "metierAlternance1",
        location: mockLocation(),
        keywords: "keywords",
        isAlternance: true,
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
      OffreEmploiSavedSearch(
        title: "titreAlternance2",
        id: "id",
        metier: "metierAlternance2",
        location: mockLocation(),
        keywords: "keywords",
        isAlternance: true,
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
    ]);
  });
}
