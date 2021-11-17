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
    final store = testStoreFactory.initializeReduxStore(initialState: _loggedInState());

    final displayedLoading =
        store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
    final successState =
        store.onChange.firstWhere((element) => element.offreEmploiSearchState is OffreEmploiSearchSuccessState);
    final savedSearch = store.onChange.firstWhere(
        (element) => element.offreEmploiSearchParametersState is OffreEmploiSearchParametersInitializedState);

    // When
    store.dispatch(SearchOffreEmploiAction(keywords: "boulanger patissier", department: "02"));

    // Then
    expect(await displayedLoading, true);
    final successAppState = await successState;
    final searchState = (successAppState.offreEmploiSearchState as OffreEmploiSearchSuccessState);
    expect(searchState.offres.length, 5);
    final savedSearchAppState = await savedSearch;
    final initializedSearchParametersState =
        (savedSearchAppState.offreEmploiSearchParametersState as OffreEmploiSearchParametersInitializedState);
    expect(initializedSearchParametersState.department, "02");
    expect(initializedSearchParametersState.keyWords, "boulanger patissier");
  });

  test("offre emplois should be fetched and an error must be displayed if something wrong happens", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiRepository = OffreEmploiRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: _loggedInState());

    final displayedLoading =
        store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchLoadingState);
    final displayedError =
        store.onChange.any((element) => element.offreEmploiSearchState is OffreEmploiSearchFailureState);

    // When
    store.dispatch(SearchOffreEmploiAction(keywords: "boulanger patissier", department: "02"));

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });
}

class OffreEmploiRepositorySuccessStub extends OffreEmploiRepository {
  OffreEmploiRepositorySuccessStub() : super("", DummyHeadersBuilder());

  @override
  Future<List<OffreEmploi>?> search({
    required String userId,
    required String keywords,
    required String department,
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
