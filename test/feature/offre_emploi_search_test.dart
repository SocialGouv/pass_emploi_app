import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

main() {
  test("offres emploi should be loaded, results displayed, and parameters saved", () async {
    // Given
    final factory = TestStoreFactory();
    factory.offreEmploiRepository = OffreEmploiRepositorySuccessWithMoreDataStub()..withOnlyAlternanceResolves(false);
    final store = factory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading = store.onChange.any((e) => e.offreEmploiSearchState is OffreEmploiSearchLoadingState);
    final successState = store.onChange.firstWhere((e) => e.offreEmploiSearchState is OffreEmploiSearchSuccessState);
    final savedSearch = store.onChange.firstWhere((e) {
      return e.offreEmploiSearchParametersState is OffreEmploiSearchParametersInitializedState;
    });

    // When
    store.dispatch(SearchOffreEmploiAction(keywords: "boulanger", location: mockLocation(), onlyAlternance: false));

    // Then
    expect(await displayedLoading, true);

    final successAppState = await successState;
    final searchState = (successAppState.offreEmploiSearchResultsState as OffreEmploiSearchResultsDataState);
    expect(searchState.offres.length, 1);
    expect(searchState.loadedPage, 1);

    final savedSearchAppState = await savedSearch;
    final state = (savedSearchAppState.offreEmploiSearchParametersState as OffreEmploiSearchParametersInitializedState);
    expect(state.location, mockLocation());
    expect(state.keywords, "boulanger");
  });

  test(
      "offres emploi should be loaded, results displayed, and parameters saved when only alternance results are requested",
      () async {
    // Given
    final factory = TestStoreFactory();
    factory.offreEmploiRepository = OffreEmploiRepositorySuccessWithMoreDataStub()..withOnlyAlternanceResolves(true);
    final store = factory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading = store.onChange.any((e) => e.offreEmploiSearchState is OffreEmploiSearchLoadingState);
    final displayedSuccess = store.onChange.any((e) => e.offreEmploiSearchState is OffreEmploiSearchSuccessState);
    final savedSearch = store.onChange.any((e) {
      return e.offreEmploiSearchParametersState is OffreEmploiSearchParametersInitializedState;
    });

    // When
    store.dispatch(SearchOffreEmploiAction(keywords: "boulanger", location: mockLocation(), onlyAlternance: true));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedSuccess, true);
    expect(await savedSearch, true);
  });

  test("offres emploi should be fetched and an error be displayed if something wrong happens", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading = store.onChange.any((e) => e.offreEmploiSearchState is OffreEmploiSearchLoadingState);
    final displayedError = store.onChange.any((e) => e.offreEmploiSearchState is OffreEmploiSearchFailureState);

    // When
    store.dispatch(SearchOffreEmploiAction(keywords: "boulanger", location: mockLocation(), onlyAlternance: false));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });
}
