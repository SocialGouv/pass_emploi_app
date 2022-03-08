import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

main() {
  group("offre emplois when data has already been loaded ...", () {
    test("and new call succeeds should append newly loaded data to existing list and set new page number", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiRepository = OffreEmploiRepositorySuccessWithMoreDataStub();
      final store = testStoreFactory.initializeReduxStore(
        initialState: loggedInState().copyWith(
          offreEmploiListState: _pageOneLoadedAndMoreDataAvailable(),
          offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
            keywords: "boulanger patissier",
            location: null,
            onlyAlternance: false,
            filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
          ),
        ),
      );

      final displayedLoading =
          store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
      final successState =
          store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);

      // When
      store.dispatch(OffreEmploiSearchRequestMoreResultsAction());

      // Then
      expect(await displayedLoading, true);
      final appState = await successState;
      expect(appState.offreEmploiSearchState is OffreEmploiSearchSuccessState, true);

      var searchResultsState = (appState.offreEmploiListState as OffreEmploiListSuccessState);
      expect(searchResultsState.offres.length, 2);
      expect(searchResultsState.loadedPage, 2);
    });

    test("and new call fails should display an error and keep previously loaded data to display it", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
      final store = testStoreFactory.initializeReduxStore(
        initialState: loggedInState().copyWith(
          offreEmploiListState: _pageOneLoadedAndMoreDataAvailable(),
          offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
            keywords: "boulanger patissier",
            location: null,
            onlyAlternance: false,
            filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
          ),
        ),
      );

      final displayedLoading =
          store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
      final errorState =
          store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchFailureState);

      // When
      store.dispatch(OffreEmploiSearchRequestMoreResultsAction());

      // Then
      expect(await displayedLoading, true);
      final appState = await errorState;
      expect(appState.offreEmploiSearchState is OffreEmploiSearchFailureState, true);

      var searchResultsState = (appState.offreEmploiListState as OffreEmploiListSuccessState);
      expect(searchResultsState.offres.length, 1);
      expect(searchResultsState.loadedPage, 1);
      expect(searchResultsState.isMoreDataAvailable, true);
    });

    test("and new call succeeds but states that no more data will be loaded should set state accordingly", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiRepository = OffreEmploiRepositorySuccessWithNoMoreDataStub();
      final store = testStoreFactory.initializeReduxStore(
        initialState: loggedInState().copyWith(
          offreEmploiListState: _pageOneLoadedAndMoreDataAvailable(),
          offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
            keywords: "boulanger patissier",
            location: null,
            onlyAlternance: false,
            filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
          ),
        ),
      );

      final successState =
          store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);

      // When
      store.dispatch(OffreEmploiSearchRequestMoreResultsAction());

      // Then
      final appState = await successState;
      expect(appState.offreEmploiSearchState is OffreEmploiSearchSuccessState, true);

      var searchResultsState = (appState.offreEmploiListState as OffreEmploiListSuccessState);
      expect(searchResultsState.offres.length, 2);
      expect(searchResultsState.loadedPage, 2);
      expect(searchResultsState.isMoreDataAvailable, false);
    });

    test("and new call requested with one already ongoing, data should not be requested again", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiRepository = OffreEmploiRepositorySuccessWithMoreDataStub();
      final store = testStoreFactory.initializeReduxStore(
        initialState: loggedInState().copyWith(
          offreEmploiListState: _pageOneLoadedAndMoreDataAvailable(),
          offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
            keywords: "boulanger patissier",
            location: null,
            onlyAlternance: false,
            filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
          ),
        ),
      );

      final successState =
          store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);

      // When
      store.dispatch(OffreEmploiSearchRequestMoreResultsAction());
      store.dispatch(OffreEmploiSearchRequestMoreResultsAction());

      // Then
      await successState;
      expect((testStoreFactory.offreEmploiRepository as OffreEmploiRepositorySuccessWithMoreDataStub).callCount, 1);
    });

    group("and last call was an error ", () {
      test("and new call fails again should display an error and keep previously loaded data to display it", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
        final store = testStoreFactory.initializeReduxStore(
          initialState: loggedInState().copyWith(
            offreEmploiListState: _pageOneLoadedAndMoreDataAvailable(),
            offreEmploiSearchState: OffreEmploiSearchState.failure(),
            offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
              keywords: "boulanger patissier",
              location: null,
              onlyAlternance: false,
              filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
            ),
          ),
        );

        final displayedLoading =
            store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
        final errorState =
            store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchFailureState);

        // When
        store.dispatch(OffreEmploiSearchRequestMoreResultsAction());

        // Then
        expect(await displayedLoading, true);
        final appState = await errorState;
        expect(appState.offreEmploiSearchState is OffreEmploiSearchFailureState, true);

        var searchResultsState = (appState.offreEmploiListState as OffreEmploiListSuccessState);
        expect(searchResultsState.offres.length, 1);
        expect(searchResultsState.loadedPage, 1);
      });

      test("and new call succeeds should append newly loaded data to existing list and set new page number", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.offreEmploiRepository = OffreEmploiRepositorySuccessWithMoreDataStub();
        final store = testStoreFactory.initializeReduxStore(
          initialState: loggedInState().copyWith(
            offreEmploiListState: _pageOneLoadedAndMoreDataAvailable(),
            offreEmploiSearchState: OffreEmploiSearchState.failure(),
            offreEmploiSearchParametersState: OffreEmploiSearchParametersInitializedState(
              keywords: "boulanger patissier",
              location: null,
              onlyAlternance: false,
              filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
            ),
          ),
        );

        final displayedLoading =
            store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
        final successState =
            store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);

        // When
        store.dispatch(OffreEmploiSearchRequestMoreResultsAction());

        // Then
        expect(await displayedLoading, true);
        final appState = await successState;
        expect(appState.offreEmploiSearchState is OffreEmploiSearchSuccessState, true);

        var searchResultsState = (appState.offreEmploiListState as OffreEmploiListSuccessState);
        expect(searchResultsState.offres.length, 2);
        expect(searchResultsState.loadedPage, 2);
      });
    });
  });
}

OffreEmploiListState _pageOneLoadedAndMoreDataAvailable() {
  return OffreEmploiListState.data(
    offres: [mockOffreEmploi()],
    loadedPage: 1,
    isMoreDataAvailable: true,
  );
}

class OffreEmploiRepositorySuccessWithNoMoreDataStub extends OffreEmploiRepository {
  OffreEmploiRepositorySuccessWithNoMoreDataStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<OffreEmploiSearchResponse?> search({required String userId, required SearchOffreEmploiRequest request}) async {
    return OffreEmploiSearchResponse(isMoreDataAvailable: false, offres: [mockOffreEmploi()]);
  }
}
