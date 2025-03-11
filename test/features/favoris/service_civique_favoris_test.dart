import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
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
    store.dispatch(FavoriUpdateRequestAction<ServiceCivique>("1", FavoriStatus.removed));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final civiqueFavorisState = (updatedFavoris.serviceCiviqueFavorisIdsState as FavoriIdsSuccessState<ServiceCivique>);
    expect(civiqueFavorisState.favoriIds, {"2", "4"});

    final favoriListState = (updatedFavoris.favoriListState as FavoriListSuccessState);
    expect(favoriListState.results, [mockFavori('2'), mockFavori('4')]);
  });

  test("favori state should not be updated when favori is removed and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["1"] == FavoriUpdateStatus.LOADING);
    final failureState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["1"] == FavoriUpdateStatus.ERROR);

    // When
    store.dispatch(FavoriUpdateRequestAction<ServiceCivique>("1", FavoriStatus.removed));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.serviceCiviqueFavorisIdsState as FavoriIdsSuccessState<ServiceCivique>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
  });

  test("favori id list should be updated when favori is added and api call succeeds", () async {
    // Given
    final Store<AppState> store = _successStoreWithFavorisAndSearchResultsLoaded();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.LOADING);
    final successState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.SUCCESS);

    // When
    store.dispatch(FavoriUpdateRequestAction<ServiceCivique>("17", FavoriStatus.added));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.serviceCiviqueFavorisIdsState as FavoriIdsSuccessState<ServiceCivique>);
    expect(favorisState.favoriIds, {"1", "2", "4", "17"});
  });

  test("favori id list should be updated when favori is added and recheche result is null", () async {
    // Given
    final Store<AppState> store = _successStoreWithFavorisAndServiceCiviqueDetailsSuccessState();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.LOADING);
    final successState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.SUCCESS);

    // When
    store.dispatch(FavoriUpdateRequestAction<ServiceCivique>("17", FavoriStatus.added));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.serviceCiviqueFavorisIdsState as FavoriIdsSuccessState<ServiceCivique>);
    expect(favorisState.favoriIds, {"2", "4", "17"});
  });

  test("favori state should not be updated when favori is added and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.LOADING);
    final failureState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.ERROR);

    // When
    store.dispatch(FavoriUpdateRequestAction<ServiceCivique>("17", FavoriStatus.added));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.serviceCiviqueFavorisIdsState as FavoriIdsSuccessState<ServiceCivique>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
  });
}

Store<AppState> _successStoreWithFavorisAndSearchResultsLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.serviceCiviqueFavorisRepository = ServiceCiviqueFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = MockAuthenticator.successful();
  final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState()
          .copyWith(
              loginState: successMiloUserState(),
              serviceCiviqueFavorisIdsState: FavoriIdsState<ServiceCivique>.success({"1", "2", "4"}))
          .successRechercheServiceCiviqueState(
    results: [mockServiceCivique(id: '1'), mockServiceCivique(id: '17')],
    canLoadMore: false,
  ).favoriListSuccessState([mockFavori('1'), mockFavori('2'), mockFavori('4')]));
  return store;
}

Store<AppState> _successStoreWithFavorisAndServiceCiviqueDetailsSuccessState() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.serviceCiviqueFavorisRepository = ServiceCiviqueFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = MockAuthenticator.successful();
  final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
          rechercheServiceCiviqueState: RechercheServiceCiviqueState.initial(),
          serviceCiviqueDetailState: ServiceCiviqueDetailSuccessState(mockServiceCiviqueDetail()),
          loginState: successMiloUserState(),
          serviceCiviqueFavorisIdsState: FavoriIdsState<ServiceCivique>.success({"2", "4"})));
  return store;
}

Store<AppState> _failureStoreWithFavorisLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.serviceCiviqueFavorisRepository = ServiceCiviqueFavorisRepositoryFailureStub();
  testStoreFactory.authenticator = MockAuthenticator.successful();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState()
        .copyWith(
            loginState: successMiloUserState(),
            serviceCiviqueFavorisIdsState: FavoriIdsState<ServiceCivique>.success({"1", "2", "4"}))
        .successRechercheServiceCiviqueState(
      results: [mockServiceCivique(id: '1'), mockServiceCivique(id: '17')],
      canLoadMore: false,
    ),
  );
  return store;
}

class ServiceCiviqueFavorisRepositorySuccessStub extends ServiceCiviqueFavorisRepository {
  ServiceCiviqueFavorisRepositorySuccessStub() : super(DioMock());

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
  }

  @override
  Future<bool> postFavori(String userId, ServiceCivique favori, {bool postulated = false}) async {
    return true;
  }

  @override
  Future<bool> deleteFavori(String userId, String offreId) async {
    return true;
  }
}

class ServiceCiviqueFavorisRepositoryFailureStub extends ServiceCiviqueFavorisRepository {
  ServiceCiviqueFavorisRepositoryFailureStub() : super(DioMock());

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
  }

  @override
  Future<bool> postFavori(String userId, ServiceCivique favori, {bool postulated = false}) async {
    return false;
  }

  @override
  Future<bool> deleteFavori(String userId, String offreId) async {
    return false;
  }
}
