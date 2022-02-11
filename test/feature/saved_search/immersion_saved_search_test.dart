import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_search_request_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/repositories/saved_search/immersion_saved_search_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

main() {
  final immersionSavedSearch = ImmersionSavedSearch(
    title: "Boulanger - Paris",
    filters: ImmersionSearchParametersFilters.withoutFilters(),
    location: "Paris",
    metier: "Boulanger",
  );

  AppState initialState = AppState.initialState().copyWith(
    immersionSavedSearchState: SavedSearchState.initialized(immersionSavedSearch),
    loginState: successMiloUserState(),
  );

  test("savedSearch should successfully update its state when savedSearch api call succeeds", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionSavedSearchRepository = ImmersionSavedSearchRepositorySuccessStub();
    testStoreFactory.authenticator = AuthenticatorLoggedInStub();
    final store = testStoreFactory.initializeReduxStore(initialState: initialState);
    final expected =
        store.onChange.firstWhere((element) => element.immersionSavedSearchState.status == SavedSearchStatus.SUCCESS);

    // When
    store.dispatch(RequestPostSavedSearchAction(immersionSavedSearch, "Boulanger - Paris"));

    // Then
    var immersionSavedSearchState = (await expected).immersionSavedSearchState;
    expect(immersionSavedSearchState is SavedSearchSuccessfullyCreated, true);
  });

  test("savedSearch should fail when savedSearch api call fails", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.immersionSavedSearchRepository = ImmersionSavedSearchRepositoryFailureStub();
    testStoreFactory.authenticator = AuthenticatorLoggedInStub();
    final store = testStoreFactory.initializeReduxStore(initialState: initialState);
    final expected =
        store.onChange.firstWhere((element) => element.immersionSavedSearchState.status == SavedSearchStatus.ERROR);

    // When
    store.dispatch(RequestPostSavedSearchAction(immersionSavedSearch, "Boulanger - Paris"));

    // Then
    var immersionSavedSearchState = (await expected).immersionSavedSearchState;
    expect(immersionSavedSearchState is SavedSearchFailureState, true);
  });

  test("InitializeSaveSearchAction should update store with rights informations", () async {
    // Given
    AppState initialState = AppState.initialState().copyWith(
      immersionSearchState: State.success([
        Immersion(
            id: "id",
            metier: "metier",
            nomEtablissement: "nomEtablissement",
            secteurActivite: "secteurActivite",
            ville: "ville")
      ]),
      immersionSearchRequestState:
          RequestedImmersionSearchRequestState(codeRome: "codeRome", latitude: 12, longitude: 34),
      loginState: successMiloUserState(),
    );
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.authenticator = AuthenticatorLoggedInStub();
    final store = testStoreFactory.initializeReduxStore(initialState: initialState);
    final expected =
        store.onChange.firstWhere((element) => element.immersionSavedSearchState is SavedSearchInitialized);

    // When
    store.dispatch(InitializeSaveSearchAction<ImmersionSavedSearch>());

    // Then
    var immersionSavedSearchState =
        (await expected).immersionSavedSearchState as SavedSearchInitialized<ImmersionSavedSearch>;
    expect(
        immersionSavedSearchState.search,
        ImmersionSavedSearch(
            title: "metier - ville",
            metier: "metier",
            location: "ville",
            filters: ImmersionSearchParametersFilters.withFilters(
              codeRome: "codeRome",
              lat: 12,
              lon: 34,
            )));
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
