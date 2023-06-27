import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/offre_emploi_saved_search_repository.dart';

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
    final offreEmploiSavedSearch = OffreEmploiSavedSearch(
        id: "id",
        title: "Boulanger",
        filters: EmploiFiltresRecherche.noFiltre(),
        keyword: "Boulanger",
        onlyAlternance: false,
        location: mockLocation(),
        metier: "Boulanger");

    final AppState initialState = AppState.initialState().copyWith(
      offreEmploiSavedSearchCreateState: SavedSearchCreateState.initialized(offreEmploiSavedSearch),
      loginState: successMiloUserState(),
    );

    test("savedSearch should successfully update its state when savedSearch api call succeeds", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiSavedSearchRepository = OffreEmploiSavedSearchRepositorySuccessStub();
      testStoreFactory.authenticator = AuthenticatorLoggedInStub();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.offreEmploiSavedSearchCreateState.status == SavedSearchCreateStatus.SUCCESS;
      });

      // When
      store.dispatch(SavedSearchCreateRequestAction(offreEmploiSavedSearch, "Boulanger"));

      // Then
      final offreEmploiSavedSearchCreateState = (await expected).offreEmploiSavedSearchCreateState;
      expect(offreEmploiSavedSearchCreateState is SavedSearchCreateSuccessfullyCreated, true);
    });

    test("savedSearch should fail when savedSearch api call fails", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiSavedSearchRepository = OffreEmploiSavedSearchRepositoryFailureStub();
      testStoreFactory.authenticator = AuthenticatorLoggedInStub();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange.firstWhere((e) {
        return e.offreEmploiSavedSearchCreateState.status == SavedSearchCreateStatus.ERROR;
      });

      // When
      store.dispatch(SavedSearchCreateRequestAction(offreEmploiSavedSearch, "Boulanger"));

      // Then
      final offreEmploiSavedSearchCreateState = (await expected).offreEmploiSavedSearchCreateState;
      expect(offreEmploiSavedSearchCreateState is SavedSearchCreateFailureState, true);
    });
  });

  group("When user tries to get a list of offre emploi/alternance saved searches ...", () {
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
      expect(savedSearches.length, 2);
      expect(savedSearches[0].getTitle(), "Boulangerie - NANTES");
      expect(savedSearches[1].getTitle(), "Flutter");
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

    group("when user request a specific saved search", () {
      final sut = StoreSut();
      sut.when(() => FetchSavedSearchResultsFromIdAction('id'));

      test('should retrieve results coming from same criteres and filtres', () {
        sut.givenStore = givenState().loggedInUser().store((factory) {
          factory.getSavedSearchRepository = SavedSearchRepositorySuccessStub();
          factory.offreEmploiRepository = OffreEmploiRepositorySuccessStub();
        });

        sut.thenExpectChangingStatesThroughOrder([_shouldInitialLoad(), _shouldSucceedWithSameCriteresAndFiltres()]);
      });
    });
  });
}

class OffreEmploiRepositorySuccessStub extends OffreEmploiRepository {
  OffreEmploiRepositorySuccessStub() : super(DioMock());

  @override
  Future<RechercheResponse<OffreEmploi>?> rechercher({
    required String userId,
    required RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> request,
  }) async {
    return RechercheResponse(results: mockOffresEmploi10(), canLoadMore: false);
  }
}

class OffreEmploiSavedSearchRepositorySuccessStub extends OffreEmploiSavedSearchRepository {
  OffreEmploiSavedSearchRepositorySuccessStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<bool> postSavedSearch(String userId, OffreEmploiSavedSearch savedSearch, String title) async {
    return true;
  }
}

class OffreEmploiSavedSearchRepositoryFailureStub extends OffreEmploiSavedSearchRepository {
  OffreEmploiSavedSearchRepositoryFailureStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<bool> postSavedSearch(String userId, OffreEmploiSavedSearch savedSearch, String title) async {
    return false;
  }
}

class SavedSearchRepositorySuccessStub extends GetSavedSearchRepository {
  SavedSearchRepositorySuccessStub() : super(DioMock(), DummyCrashlytics());

  @override
  Future<List<OffreEmploiSavedSearch>?> getSavedSearch(String userId) async {
    return _getOffreEmploiSavedSearchList();
  }
}

class SavedSearchRepositoryFailureStub extends GetSavedSearchRepository {
  SavedSearchRepositoryFailureStub() : super(DioMock(), DummyCrashlytics());

  @override
  Future<List<OffreEmploiSavedSearch>?> getSavedSearch(String userId) async {
    return null;
  }
}

List<OffreEmploiSavedSearch> _getOffreEmploiSavedSearchList() {
  return [
    OffreEmploiSavedSearch(
      id: "id",
      title: "Boulangerie - NANTES",
      metier: "Boulangerie",
      location: Location(libelle: "NANTES", code: "44109", type: LocationType.COMMUNE),
      keyword: "Boulangerie",
      onlyAlternance: false,
      filters: EmploiFiltresRecherche.withFiltres(
        distance: null,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
    OffreEmploiSavedSearch(
      id: "id2",
      title: "Flutter",
      metier: "Flutter",
      location: null,
      keyword: "Flutter",
      onlyAlternance: true,
      filters: EmploiFiltresRecherche.withFiltres(
        distance: null,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
  ];
}

Matcher _shouldInitialLoad() {
  return StateMatch((state) => state.rechercheEmploiState.status == RechercheStatus.initialLoading);
}

Matcher _shouldSucceedWithSameCriteresAndFiltres() {
  return StateMatch(
    (state) => state.rechercheEmploiState.status == RechercheStatus.success,
    (state) {
      expect(
        state.rechercheEmploiState.request!.criteres,
        EmploiCriteresRecherche(
          keyword: "Boulangerie",
          location: Location(libelle: "NANTES", code: "44109", type: LocationType.COMMUNE),
          rechercheType: RechercheType.offreEmploiAndAlternance,
        ),
      );
      expect(
        state.rechercheEmploiState.request!.filtres,
        EmploiFiltresRecherche.withFiltres(
          distance: null,
          experience: [],
          contrat: [],
          duree: [],
        ),
      );
      expect(state.rechercheEmploiState.results?.length, 10);
    },
  );
}
