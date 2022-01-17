import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_update_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:redux/src/store.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_setup.dart';

main() {
  test("favori state should be updated when favori is removed and api call succeeds", () async {
    // Given
    final Store<AppState> store = _successStoreWithFavorisAndSearchResultsLoaded();

    final loadingState = store.onChange.any((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["1"] == OffreEmploiFavorisUpdateStatus.LOADING);
    final successState = store.onChange.firstWhere((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["1"] == OffreEmploiFavorisUpdateStatus.SUCCESS);

    // When
    store.dispatch(RequestUpdateFavoriAction<OffreEmploi>("1", false));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.offreEmploiFavorisState as FavorisLoadedState<OffreEmploi>);
    expect(favorisState.favorisId, {"2", "4"});
    expect(favorisState.data, {"2": mockOffreEmploi(), "4": mockOffreEmploi()});
  });

  test("favori state should not be updated when favori is removed and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState = store.onChange.any((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["1"] == OffreEmploiFavorisUpdateStatus.LOADING);
    final failureState = store.onChange.firstWhere(
        (element) => element.offreEmploiFavorisUpdateState.requestStatus["1"] == OffreEmploiFavorisUpdateStatus.ERROR);

    // When
    store.dispatch(RequestUpdateFavoriAction<OffreEmploi>("1", false));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.offreEmploiFavorisState as FavorisLoadedState<OffreEmploi>);
    expect(favorisState.favorisId, {"1", "2", "4"});
    expect(favorisState.data, {"1": mockOffreEmploi(), "2": mockOffreEmploi(), "4": mockOffreEmploi()});
  });

  test("favori id list should be updated when favori is added and api call succeeds", () async {
    // Given
    Store<AppState> store = _successStoreWithFavorisAndSearchResultsLoaded();

    final loadingState = store.onChange.any((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["17"] == OffreEmploiFavorisUpdateStatus.LOADING);
    final successState = store.onChange.firstWhere((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["17"] == OffreEmploiFavorisUpdateStatus.SUCCESS);

    // When
    store.dispatch(RequestUpdateFavoriAction<OffreEmploi>("17", true));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.offreEmploiFavorisState as FavorisLoadedState<OffreEmploi>);
    expect(favorisState.favorisId, {"1", "2", "4", "17"});
    expect(
      favorisState.data,
      {"1": mockOffreEmploi(), "2": mockOffreEmploi(), "4": mockOffreEmploi()},
    );
  });

  test("favori state should not be updated when favori is added and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState = store.onChange.any((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["17"] == OffreEmploiFavorisUpdateStatus.LOADING);
    final failureState = store.onChange.firstWhere(
        (element) => element.offreEmploiFavorisUpdateState.requestStatus["17"] == OffreEmploiFavorisUpdateStatus.ERROR);

    // When
    store.dispatch(RequestUpdateFavoriAction<OffreEmploi>("17", true));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.offreEmploiFavorisState as FavorisLoadedState<OffreEmploi>);
    expect(favorisState.favorisId, {"1", "2", "4"});
    expect(favorisState.data, {"1": mockOffreEmploi(), "2": mockOffreEmploi(), "4": mockOffreEmploi()});
  });

  test("favori state should be updated with offres details when retrieved", () async {
    // Given
    final store = _successStoreWithFavorisIdLoaded();

    // Skip first state, because it is initially in this OffreEmploiFavorisLoadedState.
    final successState = store.onChange
        .where((element) => element.offreEmploiFavorisState is FavorisLoadedState<OffreEmploi>)
        .skip(1)
        .first;

    // When
    store.dispatch(RequestFavorisAction<OffreEmploi>());

    // Then
    final loadedFavoris = await successState;
    final favorisState = (loadedFavoris.offreEmploiFavorisState as FavorisLoadedState<OffreEmploi>);
    expect(favorisState.favorisId, {"1", "2", "4"});
    expect(favorisState.data, {
      "1": mockOffreEmploi(id: "1"),
      "2": mockOffreEmploi(id: "2"),
      "4": mockOffreEmploi(id: "4"),
    });
  });

  test("favori state should be reset when offres details fetching fails", () async {
    // Given
    final store = _failureStoreWithFavorisIdLoaded();

    final failureState =
        store.onChange.any((element) => element.offreEmploiFavorisState is FavorisNotInitialized<OffreEmploi>);

    // When
    store.dispatch(RequestFavorisAction<OffreEmploi>());

    // Then
    expect(await failureState, true);
  });
}

Store<AppState> _successStoreWithFavorisAndSearchResultsLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        offreEmploiFavorisState: FavorisState<OffreEmploi>.withMap(
          {"1", "2", "4"},
          {"1": mockOffreEmploi(), "2": mockOffreEmploi(), "4": mockOffreEmploi()},
        ),
        offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(
          offres: [mockOffreEmploi(id: '1'), mockOffreEmploi(id: '17')],
          loadedPage: 1,
          isMoreDataAvailable: false,
        )),
  );
  return store;
}

Store<AppState> _successStoreWithFavorisIdLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      offreEmploiFavorisState: FavorisState<OffreEmploi>.idsLoaded({"1", "2", "4"}),
    ),
  );
  return store;
}

Store<AppState> _failureStoreWithFavorisIdLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositoryFailureStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      offreEmploiFavorisState: FavorisState<OffreEmploi>.withMap(
        {"1", "2", "4"},
        {"1": mockOffreEmploi(), "2": mockOffreEmploi(), "4": mockOffreEmploi()},
      ),
    ),
  );
  return store;
}

Store<AppState> _failureStoreWithFavorisLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositoryFailureStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        offreEmploiFavorisState: FavorisState<OffreEmploi>.withMap(
          {"1", "2", "4"},
          {"1": mockOffreEmploi(), "2": mockOffreEmploi(), "4": mockOffreEmploi()},
        ),
        offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(
          offres: [mockOffreEmploi(id: '1'), mockOffreEmploi(id: '17')],
          loadedPage: 1,
          isMoreDataAvailable: false,
        )),
  );
  return store;
}

class OffreEmploiFavorisRepositorySuccessStub extends OffreEmploiFavorisRepository {
  OffreEmploiFavorisRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
  }

  Future<Map<String, OffreEmploi>?> getFavoris(String userId) async {
    return {
      "1": mockOffreEmploi(id: "1"),
      "2": mockOffreEmploi(id: "2"),
      "4": mockOffreEmploi(id: "4"),
    };
  }

  Future<bool> postFavori(String userId, OffreEmploi offre) async {
    return true;
  }

  Future<bool> deleteFavori(String userId, String offreId) async {
    return true;
  }
}

class OffreEmploiFavorisRepositoryFailureStub extends OffreEmploiFavorisRepository {
  OffreEmploiFavorisRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
  }

  Future<Map<String, OffreEmploi>?> getFavoris(String userId) async {
    return null;
  }

  Future<bool> postFavori(String userId, OffreEmploi offre) async {
    return false;
  }

  Future<bool> deleteFavori(String userId, String offreId) async {
    return false;
  }
}
