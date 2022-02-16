import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searchs_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/offre_emploi_saved_search_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

main() {
  group("When user tries to save an offer search ...", () {
    final offreEmploiSavedSearch = OffreEmploiSavedSearch(
        title: "Boulanger",
        id: "id",
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
        keywords: "Boulanger",
        isAlternance: false,
        location: mockLocation(),
        metier: "Boulanger");

    AppState initialState = AppState.initialState().copyWith(
      offreEmploiSavedSearchState: SavedSearchState.initialized(offreEmploiSavedSearch),
      loginState: successMiloUserState(),
    );

    test("savedSearch should successfully update its state when savedSearch api call succeeds", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiSavedSearchRepository = OffreEmploiSavedSearchRepositorySuccessStub();
      testStoreFactory.authenticator = AuthenticatorLoggedInStub();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected = store.onChange
          .firstWhere((element) => element.offreEmploiSavedSearchState.status == SavedSearchStatus.SUCCESS);

      // When
      store.dispatch(RequestPostSavedSearchAction(offreEmploiSavedSearch, "Boulanger"));

      // Then
      var offreEmploiSavedSearchState = (await expected).offreEmploiSavedSearchState;
      expect(offreEmploiSavedSearchState is SavedSearchSuccessfullyCreated, true);
    });

    test("savedSearch should fail when savedSearch api call fails", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiSavedSearchRepository = OffreEmploiSavedSearchRepositoryFailureStub();
      testStoreFactory.authenticator = AuthenticatorLoggedInStub();
      final store = testStoreFactory.initializeReduxStore(initialState: initialState);
      final expected =
          store.onChange.firstWhere((element) => element.offreEmploiSavedSearchState.status == SavedSearchStatus.ERROR);

      // When
      store.dispatch(RequestPostSavedSearchAction(offreEmploiSavedSearch, "Boulanger"));

      // Then
      var offreEmploiSavedSearchState = (await expected).offreEmploiSavedSearchState;
      expect(offreEmploiSavedSearchState is SavedSearchFailureState, true);
    });
  });

  group("When user tries to get a list of offre emploi/alternance saved searches ...", () {
    test("update state with success if repository returns data", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.getSavedSearchRepository = SavedSearchRepositorySuccessStub();
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

      final displayedLoading = store.onChange.any((element) => element.savedSearchListState.isLoading());
      final successAppState = store.onChange.firstWhere((element) => element.savedSearchListState.isSuccess());
      // When
      store.dispatch(RequestSavedSearchListAction());

      // Then
      expect(await displayedLoading, true);
      final appState = await successAppState;
      expect(appState.savedSearchListState.getResultOrThrow().length, 2);
      expect(appState.savedSearchListState.getResultOrThrow()[0].title, "Boulangerie - NANTES");
      expect(appState.savedSearchListState.getResultOrThrow()[1].title, "Flutter");
    });

    test("update state with failure if repository returns nothing", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.getSavedSearchRepository = SavedSearchRepositoryFailureStub();
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

      final displayedLoading = store.onChange.any((element) => element.savedSearchListState.isLoading());
      final failureAppState = store.onChange.firstWhere((element) => element.savedSearchListState.isFailure());

      // When
      store.dispatch(RequestSavedSearchListAction());

      // Then
      expect(await displayedLoading, true);
      final appState = await failureAppState;
      expect(appState.savedSearchListState.isFailure(), isTrue);
    });
  });
}

class OffreEmploiSavedSearchRepositorySuccessStub extends OffreEmploiSavedSearchRepository {
  OffreEmploiSavedSearchRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<bool> postSavedSearch(String userId, OffreEmploiSavedSearch savedSearch, String title) async {
    return true;
  }
}

class OffreEmploiSavedSearchRepositoryFailureStub extends OffreEmploiSavedSearchRepository {
  OffreEmploiSavedSearchRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<bool> postSavedSearch(String userId, OffreEmploiSavedSearch savedSearch, String title) async {
    return false;
  }
}

class SavedSearchRepositorySuccessStub extends GetSavedSearchRepository {
  SavedSearchRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyCrashlytics());

  @override
  Future<List<OffreEmploiSavedSearch>?> getSavedSearch(String userId) async {
    return _getOffreEmploiSavedSearchList();
  }
}

class SavedSearchRepositoryFailureStub extends GetSavedSearchRepository {
  SavedSearchRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyCrashlytics());

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
      keywords: "Boulangerie",
      isAlternance: false,
      filters: OffreEmploiSearchParametersFiltres.withFiltres(
        distance: null,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
    OffreEmploiSavedSearch(
      id: "id",
      title: "Flutter",
      metier: "Flutter",
      location: null,
      keywords: "Flutter",
      isAlternance: true,
      filters: OffreEmploiSearchParametersFiltres.withFiltres(
        distance: null,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
  ];
}
