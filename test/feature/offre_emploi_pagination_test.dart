import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';

import '../doubles/dummies.dart';
import '../models/offre_emploi_test.dart';
import '../utils/test_setup.dart';

main() {
  test("offre emplois should be fetched and displayed when screen loads", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiRepository = OffreEmploiRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: _loggedInState().copyWith(
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
    var searchState = (appState.offreEmploiSearchState as OffreEmploiSearchSuccessState);
    expect(searchState.offres.length, 10);
    expect(searchState.loadedPage, 2);
  });

  test("offre emplois should be fetched and an error must be displayed if something wrong happens", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(
      initialState: _loggedInState().copyWith(
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
    // TODO BON : this will fail / never end
    var searchState = (appState.offreEmploiSearchState as OffreEmploiSearchSuccessState);
    expect(searchState.offres.length, 5);
    expect(searchState.loadedPage, 1);
  });
}

class OffreEmploiRepositorySuccessStub extends OffreEmploiRepository {
  OffreEmploiRepositorySuccessStub() : super("", DummyHeadersBuilder());

  @override
  Future<List<OffreEmploi>?> search({
    required String userId,
    required String keywords,
    required String department,
    required int page,
  }) async {
    return offreEmploiData();
  }
}

class OffreEmploiRepositoryFailureStub extends OffreEmploiRepository {
  OffreEmploiRepositoryFailureStub() : super("", DummyHeadersBuilder());

  @override
  Future<List<OffreEmploi>?> search({
    required String userId,
    required String keywords,
    required String department,
    required int page,
  }) async {
    return null;
  }
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
