import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searchs_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/offre_emploi_saved_search_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

void main() {
  group("When user tries to save an offer search ...", () {
    final offreEmploiSavedSearch = OffreEmploiSavedSearch(
        id: "id",
        title: "Boulanger",
        filters: OffreEmploiSearchParametersFiltres.noFiltres(),
        keywords: "Boulanger",
        isAlternance: false,
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
