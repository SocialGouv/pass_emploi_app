import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

void main() {
  test("favori state should be updated when favori is removed and api call succeeds", () async {
    // Given
    final Store<AppState> store = _successStoreWithFavorisAndSearchResultsLoaded();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["1"] == FavoriUpdateStatus.LOADING);
    final successState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["1"] == FavoriUpdateStatus.SUCCESS);

    // When
    store.dispatch(FavoriUpdateRequestAction<OffreEmploi>("1", false));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.offreEmploiFavorisState as FavoriListLoadedState<OffreEmploi>);
    expect(favorisState.favoriIds, {"2", "4"});
    expect(favorisState.data, {"2": mockOffreEmploi(), "4": mockOffreEmploi()});
  });

  test("favori state should not be updated when favori is removed and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["1"] == FavoriUpdateStatus.LOADING);
    final failureState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["1"] == FavoriUpdateStatus.ERROR);

    // When
    store.dispatch(FavoriUpdateRequestAction<OffreEmploi>("1", false));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.offreEmploiFavorisState as FavoriListLoadedState<OffreEmploi>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
    expect(favorisState.data, {"1": mockOffreEmploi(), "2": mockOffreEmploi(), "4": mockOffreEmploi()});
  });

  test("favori id list should be updated when favori is added and api call succeeds", () async {
    // Given
    final Store<AppState> store = _successStoreWithFavorisAndSearchResultsLoaded();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.LOADING);
    final successState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.SUCCESS);

    // When
    store.dispatch(FavoriUpdateRequestAction<OffreEmploi>("17", true));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.offreEmploiFavorisState as FavoriListLoadedState<OffreEmploi>);
    expect(favorisState.favoriIds, {"1", "2", "4", "17"});
    expect(
      favorisState.data,
      {"1": mockOffreEmploi(), "2": mockOffreEmploi(), "4": mockOffreEmploi()},
    );
  });

  test("favori state should not be updated when favori is added and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.LOADING);
    final failureState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.ERROR);

    // When
    store.dispatch(FavoriUpdateRequestAction<OffreEmploi>("17", true));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.offreEmploiFavorisState as FavoriListLoadedState<OffreEmploi>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
    expect(favorisState.data, {"1": mockOffreEmploi(), "2": mockOffreEmploi(), "4": mockOffreEmploi()});
  });

  test("favori state should be updated with offres details when retrieved", () async {
    // Given
    final store = _successStoreWithFavorisIdLoaded();

    // Skip first state, because it is initially in this OffreEmploiFavorisLoadedState.
    final successState = store.onChange
        .where((element) => element.offreEmploiFavorisState is FavoriListLoadedState<OffreEmploi>)
        .skip(1)
        .first;

    // When
    store.dispatch(FavoriListRequestAction<OffreEmploi>());

    // Then
    final loadedFavoris = await successState;
    final favorisState = (loadedFavoris.offreEmploiFavorisState as FavoriListLoadedState<OffreEmploi>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
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
        store.onChange.any((element) => element.offreEmploiFavorisState is FavoriListNotInitialized<OffreEmploi>);

    // When
    store.dispatch(FavoriListRequestAction<OffreEmploi>());

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
        offreEmploiFavorisState: FavoriListState<OffreEmploi>.withMap(
          {"1", "2", "4"},
          {"1": mockOffreEmploi(), "2": mockOffreEmploi(), "4": mockOffreEmploi()},
        ),
        offreEmploiListState: OffreEmploiListState.data(
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
      offreEmploiFavorisState: FavoriListState<OffreEmploi>.idsLoaded({"1", "2", "4"}),
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
      offreEmploiFavorisState: FavoriListState<OffreEmploi>.withMap(
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
        offreEmploiFavorisState: FavoriListState<OffreEmploi>.withMap(
          {"1", "2", "4"},
          {"1": mockOffreEmploi(), "2": mockOffreEmploi(), "4": mockOffreEmploi()},
        ),
        offreEmploiListState: OffreEmploiListState.data(
          offres: [mockOffreEmploi(id: '1'), mockOffreEmploi(id: '17')],
          loadedPage: 1,
          isMoreDataAvailable: false,
        )),
  );
  return store;
}

class OffreEmploiFavorisRepositorySuccessStub extends OffreEmploiFavorisRepository {
  OffreEmploiFavorisRepositorySuccessStub() : super("", DummyHttpClient(), DummyPassEmploiCacheManager());

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
  }

  @override
  Future<Map<String, OffreEmploi>?> getFavoris(String userId) async {
    return {
      "1": mockOffreEmploi(id: "1"),
      "2": mockOffreEmploi(id: "2"),
      "4": mockOffreEmploi(id: "4"),
    };
  }

  @override
  Future<bool> postFavori(String userId, OffreEmploi offre) async {
    return true;
  }

  @override
  Future<bool> deleteFavori(String userId, String offreId) async {
    return true;
  }
}

class OffreEmploiFavorisRepositoryFailureStub extends OffreEmploiFavorisRepository {
  OffreEmploiFavorisRepositoryFailureStub() : super("", DummyHttpClient(), DummyPassEmploiCacheManager());

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
  }

  @override
  Future<Map<String, OffreEmploi>?> getFavoris(String userId) async {
    return null;
  }

  @override
  Future<bool> postFavori(String userId, OffreEmploi offre) async {
    return false;
  }

  @override
  Future<bool> deleteFavori(String userId, String offreId) async {
    return false;
  }
}
