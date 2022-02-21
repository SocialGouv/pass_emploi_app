import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_list_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

main() {
  final List<SavedSearch> _savedSearches = [
    ImmersionSavedSearch(
      id: "id",
      title: "titreImmersion1",
      metier: "metierImmersion1",
      location: "ville",
      filters: null,
    ),
    ImmersionSavedSearch(
      id: "id",
      title: "titreImmersion2",
      metier: "metierImmersion2",
      location: "ville",
      filters: null,
    ),
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
        savedSearchesState: State<List<SavedSearch>>.loading(),
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
        savedSearchesState: State<List<SavedSearch>>.failure(),
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
        savedSearchesState: State<List<SavedSearch>>.success(_savedSearches),
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
        location: "ville",
        filters: null,
      ),
      ImmersionSavedSearch(
        id: "id",
        title: "titreImmersion2",
        metier: "metierImmersion2",
        location: "ville",
        filters: null,
      ),
    ]);
  });

  test("create with success should load offre emploi list", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchesState: State<List<SavedSearch>>.success(_savedSearches),
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
        savedSearchesState: State<List<SavedSearch>>.success(_savedSearches),
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
        id: "id",
        title: "titreAlternance2",
        metier: "metierAlternance2",
        location: mockLocation(),
        keywords: "keywords",
        isAlternance: true,
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
    ]);
  });

  test("ViewModel with same content should be equals", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchesState: State<List<SavedSearch>>.success(_savedSearches),
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
        savedSearchesState: State<List<SavedSearch>>.success(_savedSearches),
      ),
    );
    final store2 = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchesState: State<List<SavedSearch>>.success(_savedSearches.sublist(0, 2)),
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
        savedSearchesState: State<List<SavedSearch>>.success(_savedSearches),
      ),
    );
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // When
    _savedSearches.clear();

    // Then
    expect(viewModel.savedSearches, isNotEmpty);
  });

  test("ViewModel should set navigation to offres emploi when search results are ready", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchesState: State<List<SavedSearch>>.success(_savedSearches),
        offreEmploiSearchResultsState: OffreEmploiSearchResultsDataState([], 2, true),
        offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
          keywords: "",
          onlyAlternance: true,
          location: mockLocation(),
          filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
        ),
      ),
    );
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // When
    _savedSearches.clear();

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.OFFRE_ALTERNANCE);
  });

  test("ViewModel should set navigation to offres alternances when search results are ready", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchesState: State<List<SavedSearch>>.success(_savedSearches),
        offreEmploiSearchResultsState: OffreEmploiSearchResultsDataState([], 2, true),
        offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
          keywords: "",
          onlyAlternance: false,
          location: mockLocation(),
          filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
        ),
      ),
    );
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // When
    _savedSearches.clear();

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.OFFRE_EMPLOI);
  });

  test("ViewModel should set navigation to offres immersions when search results are ready", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchesState: State<List<SavedSearch>>.success(_savedSearches),
        immersionSearchState: State.success([]),
      ),
    );
    final viewModel = SavedSearchListViewModel.createFromStore(store);

    // When
    _savedSearches.clear();

    // Then
    expect(viewModel.searchNavigationState, SavedSearchNavigationState.OFFRE_IMMERSION);
  });
}
