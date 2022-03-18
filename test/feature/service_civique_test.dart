import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_actions.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

void main() {
  test("service civique should be loaded", () async {
    // Given
    final factory = TestStoreFactory();
    factory.serviceCiviqueRepository = ServiceCiviqueRepositorySuccessWithMoreDataStub();
    final store = factory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading =
        store.onChange.any((e) => e.serviceCiviqueSearchResultState is ServiceCiviqueSearchResultLoadingState);
    final successState =
        store.onChange.firstWhere((e) => e.serviceCiviqueSearchResultState is ServiceCiviqueSearchResultDataState);

    // When
    store.dispatch(SearchServiceCiviqueAction(location: mockLocation()));

    // Then
    expect(await displayedLoading, true);

    final successAppState = await successState;
    final searchState = (successAppState.serviceCiviqueSearchResultState as ServiceCiviqueSearchResultDataState);
    expect(searchState.offres.length, 1);
    expect(searchState.lastRequest.page, 1);
  });

  test("service civique should be fetched and an error be displayed if something wrong happens", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.serviceCiviqueRepository = ServiceCiviqueRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading =
        store.onChange.any((e) => e.serviceCiviqueSearchResultState is ServiceCiviqueSearchResultLoadingState);
    final displayedError =
        store.onChange.any((e) => e.serviceCiviqueSearchResultState is ServiceCiviqueSearchResultErrorState);

    // When
    store.dispatch(SearchServiceCiviqueAction(location: mockLocation()));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });

  test("service civique should load second page", () async {
    // Given
    final factory = TestStoreFactory();
    factory.serviceCiviqueRepository = ServiceCiviqueRepositorySuccessWithMoreDataStub();
    final store = factory.initializeReduxStore(
      initialState: loggedInState().copyWith(
        serviceCiviqueSearchResultState: ServiceCiviqueSearchResultDataState(
            isMoreDataAvailable: true,
            lastRequest: SearchServiceCiviqueRequest(
              location: null,
              page: 0,
              endDate: null,
              distance: null,
              startDate: null,
              domain: null,
            ),
            offres: [
              mockServiceCivique(),
            ]),
      ),
    );

    final successState = store.onChange.firstWhere((e) =>
        e.serviceCiviqueSearchResultState is ServiceCiviqueSearchResultDataState &&
        (e.serviceCiviqueSearchResultState as ServiceCiviqueSearchResultDataState).offres.length == 2);

    // When
    store.dispatch(RequestMoreServiceCiviqueSearchResultsAction());

    // Then
    final successAppState = await successState;
    final searchState = (successAppState.serviceCiviqueSearchResultState as ServiceCiviqueSearchResultDataState);
    expect(searchState.offres.length, 2);
    expect(searchState.lastRequest.page, 1);
  });

  test("service civique can be updated with filters", () async {
    // Given
    final factory = TestStoreFactory();
    factory.serviceCiviqueRepository = ServiceCiviqueRepositorySuccessWithMoreDataStub();
    final store = factory.initializeReduxStore(
      initialState: loggedInState().copyWith(
        serviceCiviqueSearchResultState: ServiceCiviqueSearchResultDataState(
            offres: [],
            isMoreDataAvailable: true,
            lastRequest: SearchServiceCiviqueRequest(
              page: 0,
              startDate: null,
              endDate: null,
              distance: null,
              domain: null,
              location: null,
            )),
      ),
    );

    final successState = store.onChange.firstWhere((e) {
      var state = e.serviceCiviqueSearchResultState;
      return state is ServiceCiviqueSearchResultDataState && state.offres.isNotEmpty;
    });

    // When
    store.dispatch(ServiceCiviqueSearchUpdateFiltresAction(
        distance: 30, domain: Domaine.values[4], startDate: DateTime.utc(1998)));

    // Then
    final successAppState = await successState;
    final searchState = (successAppState.serviceCiviqueSearchResultState as ServiceCiviqueSearchResultDataState);
    expect(searchState.offres.length, 1);
    expect(searchState.lastRequest.page, 1);
  });
}
