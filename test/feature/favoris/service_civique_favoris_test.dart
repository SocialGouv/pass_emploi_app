import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';
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
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["1"] == FavoriUpdateStatus.LOADING);
    final successState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["1"] == FavoriUpdateStatus.SUCCESS);

    // When
    store.dispatch(FavoriUpdateRequestAction<ServiceCivique>("1", false));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.serviceCiviqueFavorisState as FavoriListLoadedState<ServiceCivique>);
    expect(favorisState.favoriIds, {"2", "4"});
    expect(favorisState.data, {"2": mockServiceCivique(), "4": mockServiceCivique()});
  });

  test("favori state should not be updated when favori is removed and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["1"] == FavoriUpdateStatus.LOADING);
    final failureState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["1"] == FavoriUpdateStatus.ERROR);

    // When
    store.dispatch(FavoriUpdateRequestAction<ServiceCivique>("1", false));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.serviceCiviqueFavorisState as FavoriListLoadedState<ServiceCivique>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
    expect(favorisState.data, {"1": mockServiceCivique(), "2": mockServiceCivique(), "4": mockServiceCivique()});
  });

  test("favori id list should be updated when favori is added and api call succeeds", () async {
    // Given
    Store<AppState> store = _successStoreWithFavorisAndSearchResultsLoaded();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.LOADING);
    final successState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.SUCCESS);

    // When
    store.dispatch(FavoriUpdateRequestAction<ServiceCivique>("17", true));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.serviceCiviqueFavorisState as FavoriListLoadedState<ServiceCivique>);
    expect(favorisState.favoriIds, {"1", "2", "4", "17"});
    expect(
      favorisState.data,
      {"1": mockServiceCivique(), "2": mockServiceCivique(), "4": mockServiceCivique()},
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
    store.dispatch(FavoriUpdateRequestAction<ServiceCivique>("17", true));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.serviceCiviqueFavorisState as FavoriListLoadedState<ServiceCivique>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
    expect(favorisState.data, {"1": mockServiceCivique(), "2": mockServiceCivique(), "4": mockServiceCivique()});
  });

  test("favori state should be updated with offres details when retrieved", () async {
    // Given
    final store = _successStoreWithFavorisIdLoaded();

    // Skip first state, because it is initially in this ImmersionFavorisLoadedState.
    final successState = store.onChange
        .where((element) => element.serviceCiviqueFavorisState is FavoriListLoadedState<ServiceCivique>)
        .skip(1)
        .first;

    // When
    store.dispatch(FavoriListRequestAction<ServiceCivique>());

    // Then
    final loadedFavoris = await successState;
    final favorisState = (loadedFavoris.serviceCiviqueFavorisState as FavoriListLoadedState<ServiceCivique>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
    expect(favorisState.data, {
      "1": mockServiceCivique(id: "1"),
      "2": mockServiceCivique(id: "2"),
      "4": mockServiceCivique(id: "4"),
    });
  });

  test("favori state should be reset when offres details fetching fails", () async {
    // Given
    final store = _failureStoreWithFavorisIdLoaded();

    final failureState =
        store.onChange.any((element) => element.serviceCiviqueFavorisState is FavoriListNotInitialized<ServiceCivique>);

    // When
    store.dispatch(FavoriListRequestAction<ServiceCivique>());

    // Then
    expect(await failureState, true);
  });
}

Store<AppState> _successStoreWithFavorisAndSearchResultsLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.serviceCiviqueFavorisRepository = ServiceCiviqueFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      serviceCiviqueFavorisState: FavoriListState<ServiceCivique>.withMap(
        {"1", "2", "4"},
        {"1": mockServiceCivique(), "2": mockServiceCivique(), "4": mockServiceCivique()},
      ),
      serviceCiviqueSearchResultState: ServiceCiviqueSearchResultDataState(
        isMoreDataAvailable: false,
        offres: [mockServiceCivique(id: '1'), mockServiceCivique(id: '17')],
        lastRequest: _mockSearchServiceCiviqueRequest(),
      ),
    ),
  );
  return store;
}

Store<AppState> _successStoreWithFavorisIdLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.serviceCiviqueFavorisRepository = ServiceCiviqueFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      serviceCiviqueFavorisState: FavoriListState<ServiceCivique>.idsLoaded({"1", "2", "4"}),
    ),
  );
  return store;
}

Store<AppState> _failureStoreWithFavorisIdLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.serviceCiviqueFavorisRepository = ServiceCiviqueFavorisRepositoryFailureStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      serviceCiviqueFavorisState: FavoriListState<ServiceCivique>.withMap(
        {"1", "2", "4"},
        {"1": mockServiceCivique(), "2": mockServiceCivique(), "4": mockServiceCivique()},
      ),
    ),
  );
  return store;
}

Store<AppState> _failureStoreWithFavorisLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.serviceCiviqueFavorisRepository = ServiceCiviqueFavorisRepositoryFailureStub();
  testStoreFactory.authenticator = AuthenticatorLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      serviceCiviqueFavorisState: FavoriListState<ServiceCivique>.withMap(
        {"1", "2", "4"},
        {"1": mockServiceCivique(), "2": mockServiceCivique(), "4": mockServiceCivique()},
      ),
      serviceCiviqueSearchResultState: ServiceCiviqueSearchResultDataState(
        isMoreDataAvailable: false,
        offres: [mockServiceCivique(id: '1'), mockServiceCivique(id: '17')],
        lastRequest: _mockSearchServiceCiviqueRequest(),
      ),
    ),
  );
  return store;
}

SearchServiceCiviqueRequest _mockSearchServiceCiviqueRequest() {
  return SearchServiceCiviqueRequest(
    location: mockLocation(),
    domain: null,
    page: 1,
    endDate: null,
    startDate: null,
    distance: 100,
  );
}

class ServiceCiviqueFavorisRepositorySuccessStub extends ServiceCiviqueFavorisRepository {
  ServiceCiviqueFavorisRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
  }

  @override
  Future<Map<String, ServiceCivique>?> getFavoris(String userId) async {
    return {
      "1": mockServiceCivique(id: "1"),
      "2": mockServiceCivique(id: "2"),
      "4": mockServiceCivique(id: "4"),
    };
  }

  @override
  Future<bool> postFavori(String userId, ServiceCivique favori) async {
    return true;
  }

  @override
  Future<bool> deleteFavori(String userId, String offreId) async {
    return true;
  }
}

class ServiceCiviqueFavorisRepositoryFailureStub extends ServiceCiviqueFavorisRepository {
  ServiceCiviqueFavorisRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
  }

  @override
  Future<Map<String, ServiceCivique>?> getFavoris(String userId) async {
    return null;
  }

  @override
  Future<bool> postFavori(String userId, ServiceCivique favori) async {
    return false;
  }

  @override
  Future<bool> deleteFavori(String userId, String offreId) async {
    return false;
  }
}
