import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_actions.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

main() {
  test("service civique should be loaded", () async {
    // Given
    final factory = TestStoreFactory();
    factory.serviceCiviqueRepository = ServiceCiviqueRepositorySuccessWithMoreDataStub();
    final store = factory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading = store.onChange.any((e) => e.serviceCiviqueSearchResultState is ServiceCiviqueSearchResultLoadingState);
    final successState = store.onChange.firstWhere((e) => e.serviceCiviqueSearchResultState is ServiceCiviqueSearchResultDataState);

    // When
    store.dispatch(SearchServiceCiviqueAction(location: mockLocation()));

    // Then
    expect(await displayedLoading, true);

    final successAppState = await successState;
    final searchState = (successAppState.serviceCiviqueSearchResultState as ServiceCiviqueSearchResultDataState);
    expect(searchState.offres.length, 1);
    expect(searchState.lastRequest.page, 0);
  });


  test("service civique should be fetched and an error be displayed if something wrong happens", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.serviceCiviqueRepository = ServiceCiviqueRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading = store.onChange.any((e) => e.serviceCiviqueSearchResultState is ServiceCiviqueSearchResultLoadingState);
    final displayedError = store.onChange.any((e) => e.serviceCiviqueSearchResultState is ServiceCiviqueSearchResultErrorState);

    // When
    store.dispatch(SearchServiceCiviqueAction(location: mockLocation()));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });
}