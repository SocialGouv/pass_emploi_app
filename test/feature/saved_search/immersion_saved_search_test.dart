import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/features/saved_search/init/saved_search_initialize_action.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/immersion_saved_search_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';
import '../../utils/test_setup.dart';

void main() {
  group("When user tries to save an offer search ...", () {
    final immersionSavedSearch = ImmersionSavedSearch(
      id: "id",
      title: "Boulanger - Paris",
      filtres: ImmersionFiltresRecherche.noFiltre(),
      location: mockLocation(),
      metier: "Boulanger",
      ville: "Paris",
      codeRome: "ROME-PARIS",
    );

    final AppState initialState = AppState.initialState().copyWith(
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
      final immersionSavedSearchState = (await expected).immersionSavedSearchCreateState;
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
      final immersionSavedSearchState = (await expected).immersionSavedSearchCreateState;
      expect(immersionSavedSearchState is SavedSearchCreateFailureState, true);
    });

    test("SaveSearchInitializeAction should update store with rights information", () async {
      // Given
      final AppState initialState = AppState.initialState().loggedInMiloUser().successRechercheImmersionState(
        results: [
          Immersion(
            id: "id",
            metier: "metier",
            nomEtablissement: "nomEtablissement",
            secteurActivite: "secteurActivite",
            ville: "ville",
          )
        ],
        request: RechercheRequest(
          ImmersionCriteresRecherche(
            metier: Metier(codeRome: 'codeRome', libelle: 'metier'),
            location: mockCommuneLocation(label: "ville", lat: 12, lon: 34),
          ),
          ImmersionFiltresRecherche.noFiltre(),
          1,
        ),
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
            location: mockCommuneLocation(label: "ville", lat: 12, lon: 34),
            ville: "ville",
            filtres: ImmersionFiltresRecherche.noFiltre(),
          ));
    });

    test("SaveSearchInitializeAction should update store with rights information when search has filtres", () async {
      // Given
      final AppState initialState = AppState.initialState().loggedInMiloUser().successRechercheImmersionState(
        results: [
          Immersion(
            id: "id",
            metier: "metier",
            nomEtablissement: "nomEtablissement",
            secteurActivite: "secteurActivite",
            ville: "ville",
          )
        ],
        request: RechercheRequest(
          ImmersionCriteresRecherche(
            metier: Metier(codeRome: 'codeRome', libelle: 'metier'),
            location: mockCommuneLocation(label: "ville", lat: 56, lon: 78),
          ),
          ImmersionFiltresRecherche.distance(27),
          1,
        ),
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
            location: mockCommuneLocation(label: "ville", lat: 56, lon: 78),
            ville: "ville",
            filtres: ImmersionFiltresRecherche.distance(27),
          ));
    });

    test("SaveSearchInitializeAction should update store with right information when search has no result", () async {
      // Given
      final AppState initialState = AppState.initialState().loggedInMiloUser().successRechercheImmersionState(
        results: [],
        request: RechercheRequest(
          ImmersionCriteresRecherche(
            metier: Metier(codeRome: 'codeRome', libelle: ''),
            location: mockCommuneLocation(label: "ville", lat: 56, lon: 78),
          ),
          ImmersionFiltresRecherche.distance(34),
          1,
        ),
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
            location: mockCommuneLocation(label: "ville", lat: 56, lon: 78),
            ville: "ville",
            filtres: ImmersionFiltresRecherche.distance(34),
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

  group("when user request a specific saved search", () {
    final sut = StoreSut();
    sut.when(() => SavedSearchGetAction('id'));

    test('should retrieve results coming from same criteres and filtres', () {
      sut.givenStore = givenState().loggedInUser().store((factory) {
        factory.getSavedSearchRepository = SavedSearchRepositorySuccessStub();
        factory.immersionRepository = ImmersionSuccessStub();
      });

      sut.thenExpectChangingStatesThroughOrder([_shouldInitialLoad(), _shouldSucceedWithSameCriteresAndFiltres()]);
    });
  });
}

class ImmersionSuccessStub extends ImmersionRepository {
  ImmersionSuccessStub() : super(DioMock());

  @override
  Future<RechercheResponse<Immersion>?> rechercher({
    required String userId,
    required RechercheRequest<ImmersionCriteresRecherche, ImmersionFiltresRecherche> request,
  }) async {
    return RechercheResponse(results: mockOffresImmersion10(), canLoadMore: false);
  }
}

class ImmersionSavedSearchRepositorySuccessStub extends ImmersionSavedSearchRepository {
  ImmersionSavedSearchRepositorySuccessStub() : super("", DummyHttpClient(), DummyPassEmploiCacheManager());

  @override
  Future<bool> postSavedSearch(String userId, ImmersionSavedSearch savedSearch, String title) async {
    return true;
  }
}

class ImmersionSavedSearchRepositoryFailureStub extends ImmersionSavedSearchRepository {
  ImmersionSavedSearchRepositoryFailureStub() : super("", DummyHttpClient(), DummyPassEmploiCacheManager());

  @override
  Future<bool> postSavedSearch(String userId, ImmersionSavedSearch savedSearch, String title) async {
    return false;
  }
}

class SavedSearchRepositorySuccessStub extends GetSavedSearchRepository {
  SavedSearchRepositorySuccessStub() : super("", DummyHttpClient(), DummyCrashlytics());

  @override
  Future<List<ImmersionSavedSearch>?> getSavedSearch(String userId) async {
    return _getImmersionSavedSearchList();
  }
}

class SavedSearchRepositoryFailureStub extends GetSavedSearchRepository {
  SavedSearchRepositoryFailureStub() : super("", DummyHttpClient(), DummyCrashlytics());

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
      location: mockCommuneLocation(label: "PARIS-14", lat: 48.830108, lon: 2.323026),
      ville: "PARIS-14",
      filtres: ImmersionFiltresRecherche.noFiltre(),
    )
  ];
}

Matcher _shouldInitialLoad() {
  return StateMatch((state) => state.rechercheImmersionState.status == RechercheStatus.initialLoading);
}

Matcher _shouldSucceedWithSameCriteresAndFiltres() {
  return StateMatch(
    (state) => state.rechercheImmersionState.status == RechercheStatus.success,
    (state) {
      expect(
        state.rechercheImmersionState.request!.criteres,
        ImmersionCriteresRecherche(
          metier: Metier(codeRome: "D1102", libelle: "Boulangerie - viennoiserie"),
          location: mockCommuneLocation(label: "PARIS-14", lat: 48.830108, lon: 2.323026),
        ),
      );
      expect(
        state.rechercheImmersionState.request!.filtres,
        ImmersionFiltresRecherche.noFiltre(),
      );
      expect(state.rechercheImmersionState.results?.length, 10);
    },
  );
}
