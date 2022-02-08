import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
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
    store.dispatch(RequestPostSavedSearchAction(immersionSavedSearch));

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
    store.dispatch(RequestPostSavedSearchAction(immersionSavedSearch));

    // Then
    var immersionSavedSearchState = (await expected).immersionSavedSearchState;
    expect(immersionSavedSearchState is SavedSearchFailureState, true);
  });
}

class ImmersionSavedSearchRepositorySuccessStub extends ImmersionSavedSearchRepository {
  ImmersionSavedSearchRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<bool> postSavedSearch(String userId, ImmersionSavedSearch savedSearch) async {
    return true;
  }
}

class ImmersionSavedSearchRepositoryFailureStub extends ImmersionSavedSearchRepository {
  ImmersionSavedSearchRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<bool> postSavedSearch(String userId, ImmersionSavedSearch savedSearch) async {
    return false;
  }
}
