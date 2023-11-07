import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/features/saved_search/init/saved_search_initialize_action.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/service_civique_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';
import '../../utils/test_setup.dart';

void main() {
  group("When user tries to save an service civique search ...", () {
    final serviceCiviqueSavedSearch = ServiceCiviqueSavedSearch(
      id: "id",
      titre: "Boulanger - Paris",
      filtres: ServiceCiviqueFiltresParameters.distance(10),
      location: mockLocation(),
      ville: "Paris",
      domaine: Domaine.values[2],
    );

    final AppState initialState = AppState.initialState().copyWith(
      serviceCiviqueSavedSearchCreateState: SavedSearchCreateState.initialized(serviceCiviqueSavedSearch),
      loginState: successMiloUserState(),
    );

    test("savedSearch should successfully update its state when savedSearch api call succeeds", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.serviceCiviqueSavedSearchRepository = ServiceCiviqueSavedSearchRepositorySuccessStub();
      testStoreFactory.authenticator = AuthenticatorLoggedInStub();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.serviceCiviqueSavedSearchCreateState.status == SavedSearchCreateStatus.SUCCESS;
      });

      // When
      store.dispatch(SavedSearchCreateRequestAction(serviceCiviqueSavedSearch, "Boulanger - Paris"));

      // Then
      final immersionSavedSearchState = (await expected).serviceCiviqueSavedSearchCreateState;
      expect(immersionSavedSearchState is SavedSearchCreateSuccessfullyCreated, true);
    });

    test("savedSearch should fail when savedSearch api call fails", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.serviceCiviqueSavedSearchRepository = ServiceCiviqueSavedSearchRepositoryFailureStub();
      testStoreFactory.authenticator = AuthenticatorLoggedInStub();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.serviceCiviqueSavedSearchCreateState.status == SavedSearchCreateStatus.ERROR;
      });

      // When
      store.dispatch(SavedSearchCreateRequestAction(serviceCiviqueSavedSearch, "Boulanger - Paris"));

      // Then
      final serviceCiviqueSavedSearchState = (await expected).serviceCiviqueSavedSearchCreateState;
      expect(serviceCiviqueSavedSearchState is SavedSearchCreateFailureState, true);
    });
  });

  test("SaveSearchInitializeAction should update store with rights information", () async {
    // Given
    final initialState = givenState() //
        .loggedInUser() //
        .successRechercheServiceCiviqueStateWithRequest(
          criteres: ServiceCiviqueCriteresRecherche(location: mockLocation()),
          filtres: ServiceCiviqueFiltresRecherche(distance: 10, startDate: null, domain: null),
        );
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.authenticator = AuthenticatorLoggedInStub();
    final store = testStoreFactory.initializeReduxStore(initialState: initialState);
    final expected = store.onChange.firstWhere((e) {
      return e.serviceCiviqueSavedSearchCreateState is SavedSearchCreateInitialized;
    });

    // When
    store.dispatch(SaveSearchInitializeAction<ServiceCiviqueSavedSearch>());

    // Then
    final state = (await expected).serviceCiviqueSavedSearchCreateState
        as SavedSearchCreateInitialized<ServiceCiviqueSavedSearch>;
    expect(
        state.search,
        ServiceCiviqueSavedSearch(
          id: "",
          domaine: null,
          titre: "",
          location: mockLocation(),
          ville: "",
          filtres: ServiceCiviqueFiltresParameters.distance(10),
        ));
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
      expect(savedSearches[0].getTitle(), "Je suis un titre");
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
    sut.whenDispatchingAction(() => FetchSavedSearchResultsFromIdAction('id'));

    test('should retrieve results coming from same criteres and filtres', () {
      sut.givenStore = givenState().loggedInUser().store((factory) {
        factory.getSavedSearchRepository = SavedSearchRepositorySuccessStub();
        factory.serviceCiviqueRepository = ServiceCiviqueRepositorySuccessStub();
      });

      sut.thenExpectChangingStatesThroughOrder([_shouldInitialLoad(), _shouldSucceedWithSameCriteresAndFiltres()]);
    });
  });
}

class ServiceCiviqueRepositorySuccessStub extends ServiceCiviqueRepository {
  ServiceCiviqueRepositorySuccessStub() : super(DioMock());

  @override
  Future<RechercheResponse<ServiceCivique>?> rechercher({
    required String userId,
    required RechercheRequest<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche> request,
  }) async {
    return RechercheResponse(results: mockOffresServiceCivique10(), canLoadMore: false);
  }
}

class ServiceCiviqueSavedSearchRepositorySuccessStub extends ServiceCiviqueSavedSearchRepository {
  ServiceCiviqueSavedSearchRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool> postSavedSearch(String userId, ServiceCiviqueSavedSearch savedSearch, String title) async {
    return true;
  }
}

class ServiceCiviqueSavedSearchRepositoryFailureStub extends ServiceCiviqueSavedSearchRepository {
  ServiceCiviqueSavedSearchRepositoryFailureStub() : super(DioMock());

  @override
  Future<bool> postSavedSearch(String userId, ServiceCiviqueSavedSearch savedSearch, String title) async {
    return false;
  }
}

class SavedSearchRepositorySuccessStub extends GetSavedSearchRepository {
  SavedSearchRepositorySuccessStub() : super(DioMock(), DummyCrashlytics());

  @override
  Future<List<ServiceCiviqueSavedSearch>?> getSavedSearch(String userId) async {
    return _getServiceCiviqueSavedSearchList();
  }
}

class SavedSearchRepositoryFailureStub extends GetSavedSearchRepository {
  SavedSearchRepositoryFailureStub() : super(DioMock(), DummyCrashlytics());

  @override
  Future<List<ServiceCiviqueSavedSearch>?> getSavedSearch(String userId) async {
    return null;
  }
}

List<ServiceCiviqueSavedSearch> _getServiceCiviqueSavedSearchList() {
  return [
    ServiceCiviqueSavedSearch(
      id: "id",
      titre: "Je suis un titre",
      location: mockCommuneLocation(),
      filtres: ServiceCiviqueFiltresParameters.distance(50),
    )
  ];
}

Matcher _shouldInitialLoad() {
  return StateMatch((state) => state.rechercheServiceCiviqueState.status == RechercheStatus.initialLoading);
}

Matcher _shouldSucceedWithSameCriteresAndFiltres() {
  return StateMatch(
    (state) => state.rechercheServiceCiviqueState.status == RechercheStatus.success,
    (state) {
      expect(
        state.rechercheServiceCiviqueState.request!.criteres,
        ServiceCiviqueCriteresRecherche(location: mockCommuneLocation()),
      );
      expect(
        state.rechercheServiceCiviqueState.request!.filtres,
        ServiceCiviqueFiltresRecherche(distance: 50, startDate: null, domain: null),
      );
      expect(state.rechercheServiceCiviqueState.results?.length, 10);
    },
  );
}
