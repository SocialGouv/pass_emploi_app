import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

main() {
  test("offre emplois should be loaded, results displayed, and parameters saved", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiRepository = OffreEmploiRepositorySuccessWithMoreDataStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final Future<bool> displayedLoading =
        store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
    final Future<AppState> successState =
        store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);
    final savedSearch = store.onChange.firstWhere(
        (element) => element.offreEmploiSearchParametersState is OffreEmploiSearchParametersInitializedState);

    // When
    store.dispatch(SearchOffreEmploiAction(keywords: "boulanger patissier", location: _location()));

    // Then
    expect(await displayedLoading, true);

    final successAppState = await successState;
    final searchState = (successAppState.offreEmploiSearchResultsState as OffreEmploiSearchResultsDataState);
    expect(searchState.offres.length, 1);
    expect(searchState.loadedPage, 1);

    final savedSearchAppState = await savedSearch;
    final initializedSearchParametersState =
        (savedSearchAppState.offreEmploiSearchParametersState as OffreEmploiSearchParametersInitializedState);
    expect(initializedSearchParametersState.location, _location());
    expect(initializedSearchParametersState.keyWords, "boulanger patissier");
  });

  test("offre emplois should be fetched and an error be displayed if something wrong happens", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());

    final displayedLoading =
        store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
    final displayedError =
        store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchFailureState);

    // When
    store.dispatch(SearchOffreEmploiAction(keywords: "boulanger patissier", location: _location()));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });
}

Location _location() => Location(libelle: "Paris", code: "75", type: LocationType.DEPARTMENT);
