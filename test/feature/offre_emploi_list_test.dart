import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

main() {
  group("offre emplois when data has already been loaded ...", () {
    test("and new call succeeds should append newly loaded data to existing list and set new page number", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiRepository = OffreEmploiRepositorySuccessWithMoreDataStub();
      final store = testStoreFactory.initializeReduxStore(
        initialState: _loggedInState().copyWith(
          offreEmploiSearchResultsState: _pageOneLoadedAndMoreDataAvailable(),
          offreEmploiSearchParametersState:
              OffreEmploiSearchParametersInitializedState(keyWords: "boulanger patissier", location: null),
        ),
      );

      final displayedLoading =
          store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
      final successState =
          store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);

      // When
      store.dispatch(RequestMoreOffreEmploiSearchResultsAction());

      // Then
      expect(await displayedLoading, true);
      final appState = await successState;
      expect(appState.offreEmploiSearchState is OffreEmploiSearchSuccessState, true);

      var searchResultsState = (appState.offreEmploiSearchResultsState as OffreEmploiSearchResultsDataState);
      expect(searchResultsState.offres.length, 2);
      expect(searchResultsState.loadedPage, 2);
    });

    test("and new call fails should display an error and keep previously loaded data to display it", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
      final store = testStoreFactory.initializeReduxStore(
        initialState: _loggedInState().copyWith(
          offreEmploiSearchResultsState: _pageOneLoadedAndMoreDataAvailable(),
          offreEmploiSearchParametersState:
              OffreEmploiSearchParametersInitializedState(keyWords: "boulanger patissier", location: null),
        ),
      );

      final displayedLoading =
          store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
      final errorState =
          store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchFailureState);

      // When
      store.dispatch(RequestMoreOffreEmploiSearchResultsAction());

      // Then
      expect(await displayedLoading, true);
      final appState = await errorState;
      expect(appState.offreEmploiSearchState is OffreEmploiSearchFailureState, true);

      var searchResultsState = (appState.offreEmploiSearchResultsState as OffreEmploiSearchResultsDataState);
      expect(searchResultsState.offres.length, 1);
      expect(searchResultsState.loadedPage, 1);
      expect(searchResultsState.isMoreDataAvailable, true);
    });

    test("and new call succeeds but states that no more data will be loaded should set state accordingly", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiRepository = OffreEmploiRepositorySuccessWithNoMoreDataStub();
      final store = testStoreFactory.initializeReduxStore(
        initialState: _loggedInState().copyWith(
          offreEmploiSearchResultsState: _pageOneLoadedAndMoreDataAvailable(),
          offreEmploiSearchParametersState:
              OffreEmploiSearchParametersInitializedState(keyWords: "boulanger patissier", location: null),
        ),
      );

      final successState =
          store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);

      // When
      store.dispatch(RequestMoreOffreEmploiSearchResultsAction());

      // Then
      final appState = await successState;
      expect(appState.offreEmploiSearchState is OffreEmploiSearchSuccessState, true);

      var searchResultsState = (appState.offreEmploiSearchResultsState as OffreEmploiSearchResultsDataState);
      expect(searchResultsState.offres.length, 2);
      expect(searchResultsState.loadedPage, 2);
      expect(searchResultsState.isMoreDataAvailable, false);
    });

    group("and last call was an error ", () {
      test("and new call fails again should display an error and keep previously loaded data to display it", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
        final store = testStoreFactory.initializeReduxStore(
          initialState: _loggedInState().copyWith(
            offreEmploiSearchResultsState: _pageOneLoadedAndMoreDataAvailable(),
            offreEmploiSearchState: OffreEmploiSearchState.failure(),
            offreEmploiSearchParametersState:
                OffreEmploiSearchParametersInitializedState(keyWords: "boulanger patissier", location: null),
          ),
        );

        final displayedLoading =
            store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
        final errorState =
            store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchFailureState);

        // When
        store.dispatch(RequestMoreOffreEmploiSearchResultsAction());

        // Then
        expect(await displayedLoading, true);
        final appState = await errorState;
        expect(appState.offreEmploiSearchState is OffreEmploiSearchFailureState, true);

        var searchResultsState = (appState.offreEmploiSearchResultsState as OffreEmploiSearchResultsDataState);
        expect(searchResultsState.offres.length, 1);
        expect(searchResultsState.loadedPage, 1);
      });

      test("and new call succeeds should append newly loaded data to existing list and set new page number", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.offreEmploiRepository = OffreEmploiRepositorySuccessWithMoreDataStub();
        final store = testStoreFactory.initializeReduxStore(
          initialState: _loggedInState().copyWith(
            offreEmploiSearchResultsState: _pageOneLoadedAndMoreDataAvailable(),
            offreEmploiSearchState: OffreEmploiSearchState.failure(),
            offreEmploiSearchParametersState:
                OffreEmploiSearchParametersInitializedState(keyWords: "boulanger patissier", location: null),
          ),
        );

        final displayedLoading =
            store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
        final successState =
            store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);

        // When
        store.dispatch(RequestMoreOffreEmploiSearchResultsAction());

        // Then
        expect(await displayedLoading, true);
        final appState = await successState;
        expect(appState.offreEmploiSearchState is OffreEmploiSearchSuccessState, true);

        var searchResultsState = (appState.offreEmploiSearchResultsState as OffreEmploiSearchResultsDataState);
        expect(searchResultsState.offres.length, 2);
        expect(searchResultsState.loadedPage, 2);
      });
    });
  });
}

OffreEmploiSearchResultsState _pageOneLoadedAndMoreDataAvailable() {
  return OffreEmploiSearchResultsState.data(
    offres: [mockOffreEmploi()],
    loadedPage: 1,
    isMoreDataAvailable: true,
  );
}

AppState _loggedInState() {
  return AppState.initialState().copyWith(
    loginState: LoginState.loggedIn(User(
      id: "id",
      firstName: "F",
      lastName: "L",
    )),
  );
}

class OffreEmploiRepositorySuccessWithNoMoreDataStub extends OffreEmploiRepository {
  OffreEmploiRepositorySuccessWithNoMoreDataStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<OffreEmploiSearchResponse?> search({
    required String userId,
    required String keywords,
    required Location? location,
    required int page,
  }) async {
    return OffreEmploiSearchResponse(isMoreDataAvailable: false, offres: [mockOffreEmploi()]);
  }
}
