import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_list_view_model.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_setup.dart';

void main() {
  final List<SavedSearch> _savedSearches = [
    ImmersionSavedSearch(
      id: "id",
      title: "titreImmersion1",
      metier: "metierImmersion1",
      codeRome: "rome",
      location: mockLocation(),
      ville: "ville",
      filtres: ImmersionSearchParametersFiltres.noFiltres(),
    ),
    ImmersionSavedSearch(
      id: "id",
      title: "titreImmersion2",
      metier: "metierImmersion2",
      codeRome: "rome",
      location: mockLocation(),
      ville: "ville",
      filtres: ImmersionSearchParametersFiltres.noFiltres(),
    ),
    OffreEmploiSavedSearch(
      id: "id",
      title: "titreOffreEmploi1",
      metier: "metierOffreEmploi1",
      location: mockLocation(),
      keyword: "keywords",
      onlyAlternance: false,
      filters: OffreEmploiSearchParametersFiltres.noFiltres(),
    ),
    OffreEmploiSavedSearch(
      title: "titreOffreEmploi2",
      id: "id",
      metier: "metierOffreEmploi2",
      location: mockLocation(),
      keyword: "keywords",
      onlyAlternance: false,
      filters: OffreEmploiSearchParametersFiltres.noFiltres(),
    ),
    OffreEmploiSavedSearch(
      id: "id",
      title: "titreAlternance1",
      metier: "metierAlternance1",
      location: mockLocation(),
      keyword: "keywords",
      onlyAlternance: true,
      filters: OffreEmploiSearchParametersFiltres.noFiltres(),
    ),
    OffreEmploiSavedSearch(
      id: "id",
      title: "titreAlternance2",
      metier: "metierAlternance2",
      location: mockLocation(),
      keyword: "keywords",
      onlyAlternance: true,
      filters: OffreEmploiSearchParametersFiltres.noFiltres(),
    ),
  ];

  test("create should set loading properly", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: SavedSearchListLoadingState(),
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
        savedSearchListState: SavedSearchListFailureState(),
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
        savedSearchListState: SavedSearchListSuccessState(_savedSearches),
      ),
    );

    // When
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.getImmersions(), [
      ImmersionSavedSearch(
        id: "id",
        title: "titreImmersion1",
        metier: "metierImmersion1",
        codeRome: "rome",
        location: mockLocation(),
        ville: "ville",
        filtres: ImmersionSearchParametersFiltres.noFiltres(),
      ),
      ImmersionSavedSearch(
        id: "id",
        title: "titreImmersion2",
        metier: "metierImmersion2",
        codeRome: "rome",
        location: mockLocation(),
        ville: "ville",
        filtres: ImmersionSearchParametersFiltres.noFiltres(),
      ),
    ]);
  });

  test("create with success should load offre emploi list", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: SavedSearchListSuccessState(_savedSearches),
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
        keyword: "keywords",
        onlyAlternance: false,
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
      OffreEmploiSavedSearch(
        id: "id",
        title: "titreOffreEmploi2",
        metier: "metierOffreEmploi2",
        location: mockLocation(),
        keyword: "keywords",
        onlyAlternance: false,
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
    ]);
  });

  test("create with success should load alternance list", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: SavedSearchListSuccessState(_savedSearches),
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
        keyword: "keywords",
        onlyAlternance: true,
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
      OffreEmploiSavedSearch(
        id: "id",
        title: "titreAlternance2",
        metier: "metierAlternance2",
        location: mockLocation(),
        keyword: "keywords",
        onlyAlternance: true,
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
    ]);
  });

  test("ViewModel with same content should be equals", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: SavedSearchListSuccessState(_savedSearches),
      ),
    );

    // When
    final viewModel1 = SavedSearchListViewModel.createFromStore(store);
    final viewModel2 = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel1 == viewModel2, isTrue);
  });

  test("ViewModel with different content should not be equals", () {
    // Given
    final store1 = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: SavedSearchListSuccessState(_savedSearches),
      ),
    );
    final store2 = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: SavedSearchListSuccessState(_savedSearches.sublist(0, 2)),
      ),
    );

    // When
    final viewModel1 = SavedSearchListViewModel.createFromStore(store1);
    final viewModel2 = SavedSearchListViewModel.createFromStore(store2);

    // Then
    expect(viewModel1 == viewModel2, isFalse);
  });

  test(
      "ViewModel MUST create a copy and not just a reference of state's saved searches to ensure StoreConnector.distinct properly works",
      () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchListState: SavedSearchListSuccessState(_savedSearches),
      ),
    );

    // When
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel.savedSearches, isNotEmpty);
  });

  test("ViewModel should set navigation to offres emploi when search results are ready", () {
    // Given
    final store = givenState()
        .copyWith(savedSearchListState: SavedSearchListSuccessState(_savedSearches))
        .successRechercheEmploiState()
        .store();

    // When
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.OFFRE_EMPLOI);
  });

  test("ViewModel should set navigation to offres alternances when search results are ready", () {
    // Given
    final store = givenState()
        .copyWith(savedSearchListState: SavedSearchListSuccessState(_savedSearches))
        .successRechercheEmploiStateWithRequest(
          criteres: EmploiCriteresRecherche(
            keyword: "keyword",
            location: null,
            onlyAlternance: true,
          ),
        )
        .store();

    // When
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.OFFRE_ALTERNANCE);
  });

  test("ViewModel should set navigation to offres immersions when search results are ready", () {
    // Given
    final store = givenState()
        .copyWith(savedSearchListState: SavedSearchListSuccessState(_savedSearches))
        .successRechercheImmersionState()
        .store();

    // When
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.OFFRE_IMMERSION);
  });

  test("ViewModel should set navigation to service civique when search results are ready", () {
    // Given
    final store = givenState()
        .copyWith(savedSearchListState: SavedSearchListSuccessState(_savedSearches))
        .successRechercheServiceCiviqueState()
        .store();

    // When
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.SERVICE_CIVIQUE);
  });
}
