import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/features/immersion/saved_search/immersion_saved_search_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/features/saved_search/init/saved_search_initialize_action.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searchs_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/immersion_saved_search_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';
import '../immersion/immersion_list_test.dart';

main() {
  group("When user tries to save an offer search ...", () {
    final immersionSavedSearch = ImmersionSavedSearch(
      id: "id",
      title: "Boulanger - Paris",
      filtres: ImmersionSearchParametersFiltres.noFiltres(),
      location: mockLocation(),
      metier: "Boulanger",
      ville: "Paris",
      codeRome: "ROME-PARIS",
    );

    AppState initialState = AppState.initialState().copyWith(
      immersionSavedSearchCreateState: SavedSearchCreateState.initialized(immersionSavedSearch),
      loginState: successMiloUserState(),
    );

    test("savedSearch should successfully update its state when savedSearch api call succeeds", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.immersionSavedSearchRepository = ImmersionSavedSearchRepositorySuccessStub();
      testStoreFactory.authenticator = AuthenticatorLoggedInStub();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.immersionSavedSearchCreateState.status == SavedSearchCreateStatus.SUCCESS;
      });

      // When
      store.dispatch(SavedSearchCreateRequestAction(immersionSavedSearch, "Boulanger - Paris"));

      // Then
      var immersionSavedSearchState = (await expected).immersionSavedSearchCreateState;
      expect(immersionSavedSearchState is SavedSearchCreateSuccessfullyCreated, true);
    });

    test("savedSearch should fail when savedSearch api call fails", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.immersionSavedSearchRepository = ImmersionSavedSearchRepositoryFailureStub();
      testStoreFactory.authenticator = AuthenticatorLoggedInStub();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.immersionSavedSearchCreateState.status == SavedSearchCreateStatus.ERROR;
      });

      // When
      store.dispatch(SavedSearchCreateRequestAction(immersionSavedSearch, "Boulanger - Paris"));

      // Then
      var immersionSavedSearchState = (await expected).immersionSavedSearchCreateState;
      expect(immersionSavedSearchState is SavedSearchCreateFailureState, true);
    });

    test("SaveSearchInitializeAction should update store with rights information", () async {
      // Given
      AppState initialState = AppState.initialState().copyWith(
        immersionListState: ImmersionListSuccessState([
          Immersion(
              id: "id",
              metier: "metier",
              nomEtablissement: "nomEtablissement",
              secteurActivite: "secteurActivite",
              ville: "ville")
        ]),
        immersionSearchParametersState: ImmersionSearchParametersInitializedState(
          codeRome: "codeRome",
          location: mockLocation(lat: 12, lon: 34),
          ville: "ville",
          filtres: ImmersionSearchParametersFiltres.noFiltres(),
        ),
        loginState: successMiloUserState(),
      );
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.authenticator = AuthenticatorLoggedInStub();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.immersionSavedSearchCreateState is SavedSearchCreateInitialized;
      });

      // When
      store.dispatch(SaveSearchInitializeAction<ImmersionSavedSearch>());

      // Then
      final state =
          (await expected).immersionSavedSearchCreateState as SavedSearchCreateInitialized<ImmersionSavedSearch>;
      expect(
          state.search,
          ImmersionSavedSearch(
            id: "",
            title: "metier - ville",
            codeRome: "codeRome",
            metier: "metier",
            location: mockLocation(lat: 12, lon: 34),
            ville: "ville",
            filtres: ImmersionSearchParametersFiltres.noFiltres(),
          ));
    });

    test("SaveSearchInitializeAction should update store with rights information when search has filtres", () async {
      // Given
      AppState initialState = AppState.initialState().copyWith(
        immersionListState: ImmersionListSuccessState([
          Immersion(
            id: "id",
            metier: "metier",
            nomEtablissement: "nomEtablissement",
            secteurActivite: "secteurActivite",
            ville: "ville",
          )
        ]),
        immersionSearchParametersState: ImmersionSearchParametersInitializedState(
          codeRome: "codeRome",
          location: mockLocation(lat: 56, lon: 78),
          ville: "ville",
          filtres: ImmersionSearchParametersFiltres.distance(27),
        ),
        loginState: successMiloUserState(),
      );
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.authenticator = AuthenticatorLoggedInStub();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.immersionSavedSearchCreateState is SavedSearchCreateInitialized;
      });

      // When
      store.dispatch(SaveSearchInitializeAction<ImmersionSavedSearch>());

      // Then
      final state =
          (await expected).immersionSavedSearchCreateState as SavedSearchCreateInitialized<ImmersionSavedSearch>;
      expect(
          state.search,
          ImmersionSavedSearch(
            id: "",
            title: "metier - ville",
            codeRome: "codeRome",
            metier: "metier",
            location: mockLocation(lat: 56, lon: 78),
            ville: "ville",
            filtres: ImmersionSearchParametersFiltres.distance(27),
          ));
    });

    test("SaveSearchInitializeAction should update store with right information when search has no result", () async {
      // Given
      AppState initialState = AppState.initialState().copyWith(
        immersionListState: ImmersionListSuccessState([]),
        immersionSearchParametersState: ImmersionSearchParametersInitializedState(
          codeRome: "codeRome",
          location: mockLocation(lat: 56, lon: 78),
          ville: "ville",
          filtres: ImmersionSearchParametersFiltres.distance(34),
        ),
        loginState: successMiloUserState(),
      );
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.authenticator = AuthenticatorLoggedInStub();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.immersionSavedSearchCreateState is SavedSearchCreateInitialized;
      });

      // When
      store.dispatch(SaveSearchInitializeAction<ImmersionSavedSearch>());

      // Then
      final state =
          (await expected).immersionSavedSearchCreateState as SavedSearchCreateInitialized<ImmersionSavedSearch>;
      expect(
          state.search,
          ImmersionSavedSearch(
            id: "",
            title: " - ville",
            codeRome: "codeRome",
            metier: "",
            location: mockLocation(lat: 56, lon: 78),
            ville: "ville",
            filtres: ImmersionSearchParametersFiltres.distance(34),
          ));
    });
  });

  group("When user tries to get a list of immersion saved searches ...", () {
    test("update state with success if repository returns data", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.getSavedSearchRepository = SavedSearchRepositorySuccessStub();
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

      final displayedLoading = store.onChange.any((e) => e.savedSearchListState is SavedSearchListLoadingState);
      final successAppState = store.onChange.firstWhere((e) => e.savedSearchListState is SavedSearchListSuccessState);
      // When
      store.dispatch(SavedSearchListRequestAction());

      // Then
      expect(await displayedLoading, true);
      final appState = await successAppState;
      final savedSearches = (appState.savedSearchListState as SavedSearchListSuccessState).savedSearches;
      expect(savedSearches, isNotNull);
      expect(savedSearches.length, 1);
      expect(savedSearches[0].getTitle(), "Boulangerie - viennoiserie - PARIS-14");
    });

    test("update state with failure if repository returns nothing", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.getSavedSearchRepository = SavedSearchRepositoryFailureStub();
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

      final displayedLoading = store.onChange.any((e) => e.savedSearchListState is SavedSearchListLoadingState);
      final failureAppState = store.onChange.firstWhere((e) => e.savedSearchListState is SavedSearchListFailureState);

      // When
      store.dispatch(SavedSearchListRequestAction());

      // Then
      expect(await displayedLoading, true);
      final appState = await failureAppState;
      expect(appState.savedSearchListState is SavedSearchListFailureState, isTrue);
    });
  });

  test(
      "when user launches a search from a saved search with no filtres should display loading and fetch immersions and properly set parameters state",
      () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionRepository = ImmersionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading = store.onChange.any((e) => e.immersionListState is ImmersionListLoadingState);
    final successAppState = store.onChange.firstWhere((e) => e.immersionListState is ImmersionListSuccessState);

    // When
    store.dispatch(
      SavedImmersionSearchRequestAction(
        codeRome: "code-rome",
        location: mockCommuneLocation(label: "Marseille"),
        filtres: ImmersionSearchParametersFiltres.noFiltres(),
      ),
    );

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    final immersionListState = (appState.immersionListState as ImmersionListSuccessState);
    final immersionParameterState =
        (appState.immersionSearchParametersState as ImmersionSearchParametersInitializedState);
    expect(immersionListState.immersions, isNotEmpty);
    expect(
        immersionParameterState,
        ImmersionSearchParametersInitializedState(
          codeRome: "code-rome",
          location: mockCommuneLocation(label: "Marseille"),
          ville: "Marseille",
          filtres: ImmersionSearchParametersFiltres.noFiltres(),
        ));
  });

  test("when user launches a search from a saved search with distance filtre", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionRepository = ImmersionRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading = store.onChange.any((e) => e.immersionListState is ImmersionListLoadingState);
    final successAppState = store.onChange.firstWhere((e) => e.immersionListState is ImmersionListSuccessState);

    // When
    store.dispatch(
      SavedImmersionSearchRequestAction(
        codeRome: "code-rome",
        location: mockCommuneLocation(label: "Strasbourg"),
        filtres: ImmersionSearchParametersFiltres.distance(70),
      ),
    );

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    final immersionListState = (appState.immersionListState as ImmersionListSuccessState);
    final immersionParameterState =
        (appState.immersionSearchParametersState as ImmersionSearchParametersInitializedState);
    expect(immersionListState.immersions, isNotEmpty);
    expect(
        immersionParameterState,
        ImmersionSearchParametersInitializedState(
          codeRome: "code-rome",
          location: mockCommuneLocation(label: "Strasbourg"),
          ville: "Strasbourg",
          filtres: ImmersionSearchParametersFiltres.distance(70),
        ));
  });
}

class ImmersionSavedSearchRepositorySuccessStub extends ImmersionSavedSearchRepository {
  ImmersionSavedSearchRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<bool> postSavedSearch(String userId, ImmersionSavedSearch savedSearch, String title) async {
    return true;
  }
}

class ImmersionSavedSearchRepositoryFailureStub extends ImmersionSavedSearchRepository {
  ImmersionSavedSearchRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<bool> postSavedSearch(String userId, ImmersionSavedSearch savedSearch, String title) async {
    return false;
  }
}

class SavedSearchRepositorySuccessStub extends GetSavedSearchRepository {
  SavedSearchRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyCrashlytics());

  @override
  Future<List<ImmersionSavedSearch>?> getSavedSearch(String userId) async {
    return _getImmersionSavedSearchList();
  }
}

class SavedSearchRepositoryFailureStub extends GetSavedSearchRepository {
  SavedSearchRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyCrashlytics());

  @override
  Future<List<ImmersionSavedSearch>?> getSavedSearch(String userId) async {
    return null;
  }
}

List<ImmersionSavedSearch> _getImmersionSavedSearchList() {
  return [
    ImmersionSavedSearch(
      id: "id",
      title: "Boulangerie - viennoiserie - PARIS-14",
      codeRome: "D1102",
      metier: "Boulangerie - viennoiserie",
      location: mockLocation(lat: 48.830108, lon: 2.323026),
      ville: "PARIS-14",
      filtres: ImmersionSearchParametersFiltres.noFiltres(),
    )
  ];
}
