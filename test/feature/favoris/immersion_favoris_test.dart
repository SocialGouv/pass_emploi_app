import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_update_state.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

main() {
  test("favori state should be updated when favori is removed and api call succeeds", () async {
    // Given
    final Store<AppState> store = _successStoreWithFavorisAndSearchResultsLoaded();

    final loadingState =
        store.onChange.any((element) => element.favorisUpdateState.requestStatus["1"] == FavorisUpdateStatus.LOADING);
    final successState = store.onChange
        .firstWhere((element) => element.favorisUpdateState.requestStatus["1"] == FavorisUpdateStatus.SUCCESS);

    // When
    store.dispatch(RequestUpdateFavoriAction<Immersion>("1", false));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.immersionFavorisState as FavorisLoadedState<Immersion>);
    expect(favorisState.favoriIds, {"2", "4"});
    expect(favorisState.data, {"2": mockImmersion(), "4": mockImmersion()});
  });

  test("favori state should not be updated when favori is removed and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState =
        store.onChange.any((element) => element.favorisUpdateState.requestStatus["1"] == FavorisUpdateStatus.LOADING);
    final failureState = store.onChange
        .firstWhere((element) => element.favorisUpdateState.requestStatus["1"] == FavorisUpdateStatus.ERROR);

    // When
    store.dispatch(RequestUpdateFavoriAction<Immersion>("1", false));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.immersionFavorisState as FavorisLoadedState<Immersion>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
    expect(favorisState.data, {"1": mockImmersion(), "2": mockImmersion(), "4": mockImmersion()});
  });

  test("favori id list should be updated when favori is added and api call succeeds", () async {
    // Given
    Store<AppState> store = _successStoreWithFavorisAndSearchResultsLoaded();

    final loadingState =
        store.onChange.any((element) => element.favorisUpdateState.requestStatus["17"] == FavorisUpdateStatus.LOADING);
    final successState = store.onChange
        .firstWhere((element) => element.favorisUpdateState.requestStatus["17"] == FavorisUpdateStatus.SUCCESS);

    // When
    store.dispatch(RequestUpdateFavoriAction<Immersion>("17", true));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.immersionFavorisState as FavorisLoadedState<Immersion>);
    expect(favorisState.favoriIds, {"1", "2", "4", "17"});
    expect(
      favorisState.data,
      {"1": mockImmersion(), "2": mockImmersion(), "4": mockImmersion()},
    );
  });

  test("favori state should not be updated when favori is added and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState =
        store.onChange.any((element) => element.favorisUpdateState.requestStatus["17"] == FavorisUpdateStatus.LOADING);
    final failureState = store.onChange
        .firstWhere((element) => element.favorisUpdateState.requestStatus["17"] == FavorisUpdateStatus.ERROR);

    // When
    store.dispatch(RequestUpdateFavoriAction<Immersion>("17", true));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.immersionFavorisState as FavorisLoadedState<Immersion>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
    expect(favorisState.data, {"1": mockImmersion(), "2": mockImmersion(), "4": mockImmersion()});
  });

  test("favori state should be updated with offres details when retrieved", () async {
    // Given
    final store = _successStoreWithFavorisIdLoaded();

    // Skip first state, because it is initially in this ImmersionFavorisLoadedState.
    final successState =
        store.onChange.where((element) => element.immersionFavorisState is FavorisLoadedState<Immersion>).skip(1).first;

    // When
    store.dispatch(FavoriListRequestAction<Immersion>());

    // Then
    final loadedFavoris = await successState;
    final favorisState = (loadedFavoris.immersionFavorisState as FavorisLoadedState<Immersion>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
    expect(favorisState.data, {
      "1": mockImmersion(id: "1"),
      "2": mockImmersion(id: "2"),
      "4": mockImmersion(id: "4"),
    });
  });

  test("favori state should be reset when offres details fetching fails", () async {
    // Given
    final store = _failureStoreWithFavorisIdLoaded();

    final failureState =
        store.onChange.any((element) => element.immersionFavorisState is FavorisNotInitialized<Immersion>);

    // When
    store.dispatch(FavoriListRequestAction<Immersion>());

    // Then
    expect(await failureState, true);
  });
}

Store<AppState> _successStoreWithFavorisAndSearchResultsLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.immersionFavorisRepository = ImmersionFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      immersionFavorisState: FavorisState<Immersion>.withMap(
        {"1", "2", "4"},
        {"1": mockImmersion(), "2": mockImmersion(), "4": mockImmersion()},
      ),
      immersionListState: ImmersionListSuccessState([mockImmersion(id: '1'), mockImmersion(id: '17')]),
    ),
  );
  return store;
}

Store<AppState> _successStoreWithFavorisIdLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.immersionFavorisRepository = ImmersionFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      immersionFavorisState: FavorisState<Immersion>.idsLoaded({"1", "2", "4"}),
    ),
  );
  return store;
}

Store<AppState> _failureStoreWithFavorisIdLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.immersionFavorisRepository = ImmersionFavorisRepositoryFailureStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      immersionFavorisState: FavorisState<Immersion>.withMap(
        {"1", "2", "4"},
        {"1": mockImmersion(), "2": mockImmersion(), "4": mockImmersion()},
      ),
    ),
  );
  return store;
}

Store<AppState> _failureStoreWithFavorisLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.immersionFavorisRepository = ImmersionFavorisRepositoryFailureStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      immersionFavorisState: FavorisState<Immersion>.withMap(
        {"1", "2", "4"},
        {"1": mockImmersion(), "2": mockImmersion(), "4": mockImmersion()},
      ),
      immersionListState: ImmersionListSuccessState([mockImmersion(id: '1'), mockImmersion(id: '17')]),
    ),
  );
  return store;
}

class ImmersionFavorisRepositorySuccessStub extends ImmersionFavorisRepository {
  ImmersionFavorisRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
  }

  @override
  Future<Map<String, Immersion>?> getFavoris(String userId) async {
    return {
      "1": mockImmersion(id: "1"),
      "2": mockImmersion(id: "2"),
      "4": mockImmersion(id: "4"),
    };
  }

  @override
  Future<bool> postFavori(String userId, Immersion favori) async {
    return true;
  }

  @override
  Future<bool> deleteFavori(String userId, String offreId) async {
    return true;
  }
}

class ImmersionFavorisRepositoryFailureStub extends ImmersionFavorisRepository {
  ImmersionFavorisRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
  }

  @override
  Future<Map<String, Immersion>?> getFavoris(String userId) async {
    return null;
  }

  @override
  Future<bool> postFavori(String userId, Immersion favori) async {
    return false;
  }

  @override
  Future<bool> deleteFavori(String userId, String offreId) async {
    return false;
  }
}
