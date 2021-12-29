import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

main() {
  test("applying new filtres when call succeeds should replace all existing data and filtres should be stored",
      () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final repositoryMock = OffreEmploiRepositorySuccessWithMoreDataMock();
    testStoreFactory.offreEmploiRepository = repositoryMock;
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInState().copyWith(
        offreEmploiSearchResultsState: _pageOneLoadedAndMoreDataAvailable(),
        offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
          keyWords: "boulanger patissier",
          location: null,
          filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
        ),
      ),
    );

    final displayedLoading =
        store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
    final successState =
        store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);

    // When
    store.dispatch(OffreEmploiSearchUpdateFiltresAction(OffreEmploiSearchParametersFiltres.withFiltres(distance: 40)));

    // Then
    expect(await displayedLoading, true);
    final appState = await successState;
    expect(appState.offreEmploiSearchState is OffreEmploiSearchSuccessState, true);

    final searchResultsState = (appState.offreEmploiSearchResultsState as OffreEmploiSearchResultsDataState);
    expect(searchResultsState.offres.length, 3);
    expect(searchResultsState.loadedPage, 1);

    final paramsState = (appState.offreEmploiSearchParametersState as OffreEmploiSearchParametersInitializedState);
    expect(paramsState.filtres.distance, 40);

    expect(repositoryMock.wasCalledWithFiltres, isTrue);
  });

  test("applying new filtres when call fails should leave all existing data alone but filtres should be stored",
      () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInState().copyWith(
        offreEmploiSearchResultsState: _pageOneLoadedAndMoreDataAvailable(),
        offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
          keyWords: "boulanger patissier",
          location: null,
          filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
        ),
      ),
    );

    final displayedLoading =
        store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
    // TODO BON EST-CE QU'ON FAIT VRAIMENT CA ?
    final failureButStillSuccessState =
        store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);

    // When
    store.dispatch(OffreEmploiSearchUpdateFiltresAction(OffreEmploiSearchParametersFiltres.withFiltres(distance: 40)));

    // Then
    expect(await displayedLoading, true);
    final appState = await failureButStillSuccessState;
    expect(appState.offreEmploiSearchState is OffreEmploiSearchSuccessState, true);

    final searchResultsState = (appState.offreEmploiSearchResultsState as OffreEmploiSearchResultsDataState);
    expect(searchResultsState.offres.length, 1);
    expect(searchResultsState.loadedPage, 1);

    final paramsState = (appState.offreEmploiSearchParametersState as OffreEmploiSearchParametersInitializedState);
    expect(paramsState.filtres.distance, 40);
  });
}

OffreEmploiSearchResultsState _pageOneLoadedAndMoreDataAvailable() {
  return OffreEmploiSearchResultsState.data(
    offres: [mockOffreEmploi()],
    loadedPage: 1,
    isMoreDataAvailable: true,
  );
}

class OffreEmploiRepositorySuccessWithMoreDataMock extends OffreEmploiRepository {
  OffreEmploiRepositorySuccessWithMoreDataMock() : super("", DummyHttpClient(), DummyHeadersBuilder());

  bool wasCalledWithFiltres = false;

  @override
  Future<OffreEmploiSearchResponse?> search({
    required String userId,
    required String keywords,
    required Location? location,
    required int page,
    required OffreEmploiSearchParametersFiltres filtres,
  }) async {
    if (filtres.distance == 40) {
      wasCalledWithFiltres = true;
    }
    return OffreEmploiSearchResponse(isMoreDataAvailable: true, offres: [
      mockOffreEmploi(),
      mockOffreEmploi(),
      mockOffreEmploi(),
    ]);
  }
}
