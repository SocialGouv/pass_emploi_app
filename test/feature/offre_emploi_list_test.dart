import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';

import '../doubles/stubs.dart';
import '../models/offre_emploi_test.dart';
import '../utils/test_setup.dart';

main() {
  group("offre emplois when data has already been loaded ...", () {
    test("and new call succeeds should append newly loaded data to existing list and set new page number", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiRepository = OffreEmploiRepositorySuccessStub();
      final store = testStoreFactory.initializeReduxStore(
        initialState: _loggedInState().copyWith(
          offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(offreEmploiData(), 1),
          offreEmploiSearchParametersState:
              OffreEmploiSearchParametersInitializedState(keyWords: "boulanger patissier", department: "92"),
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
      expect(searchResultsState.offres.length, 10);
      expect(searchResultsState.loadedPage, 2);
    });

    test("and new call fails should display an error and keep previously loaded data to display it", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
      final store = testStoreFactory.initializeReduxStore(
        initialState: _loggedInState().copyWith(
          offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(offreEmploiData(), 1),
          offreEmploiSearchParametersState:
              OffreEmploiSearchParametersInitializedState(keyWords: "boulanger patissier", department: "92"),
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
      expect(searchResultsState.offres.length, 5);
      expect(searchResultsState.loadedPage, 1);
    });

    group("and last call was an error ", () {
      test("and new call fails again should display an error and keep previously loaded data to display it", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
        final store = testStoreFactory.initializeReduxStore(
          initialState: _loggedInState().copyWith(
            offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(offreEmploiData(), 1),
            offreEmploiSearchState: OffreEmploiSearchState.failure(),
            offreEmploiSearchParametersState:
                OffreEmploiSearchParametersInitializedState(keyWords: "boulanger patissier", department: "92"),
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
        expect(searchResultsState.offres.length, 5);
        expect(searchResultsState.loadedPage, 1);
      });

      test("and new call succeeds should append newly loaded data to existing list and set new page number", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        testStoreFactory.offreEmploiRepository = OffreEmploiRepositorySuccessStub();
        final store = testStoreFactory.initializeReduxStore(
          initialState: _loggedInState().copyWith(
            offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(offreEmploiData(), 1),
            offreEmploiSearchState: OffreEmploiSearchState.failure(),
            offreEmploiSearchParametersState:
                OffreEmploiSearchParametersInitializedState(keyWords: "boulanger patissier", department: "92"),
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
        expect(searchResultsState.offres.length, 10);
        expect(searchResultsState.loadedPage, 2);
      });
    });
  });

  test("all offre emplois state should reset on ResetOffreEmploiSearchResultsAction", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final store = testStoreFactory.initializeReduxStore(
      initialState: _loggedInState().copyWith(
        offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(offreEmploiData(), 1),
        offreEmploiSearchParametersState:
            OffreEmploiSearchParametersInitializedState(keyWords: "boulanger patissier", department: "92"),
      ),
    );
    final dataNotInitializedState = store.onChange
        .firstWhere((element) => element.offreEmploiSearchResultsState is OffreEmploiSearchResultsNotInitializedState);

    // When
    store.dispatch(ResetOffreEmploiSearchResultsAction());

    // Then
    final resetAppState = await dataNotInitializedState;
    expect(resetAppState.offreEmploiSearchResultsState is OffreEmploiSearchResultsNotInitializedState, true);
    expect(resetAppState.offreEmploiSearchParametersState is OffreEmploiSearchParametersStateNotInitializedState, true);
    expect(resetAppState.offreEmploiSearchState is OffreEmploiSearchNotInitializedState, true);
  });
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
