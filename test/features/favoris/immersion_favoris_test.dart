import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
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
    store.dispatch(FavoriUpdateRequestAction<Immersion>("1", FavoriStatus.removed));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final immersionFavoriState = (updatedFavoris.immersionFavorisIdsState as FavoriIdsSuccessState<Immersion>);
    expect(immersionFavoriState.favoriIds, {"2", "4"});

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
    store.dispatch(FavoriUpdateRequestAction<Immersion>("1", FavoriStatus.removed));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.immersionFavorisIdsState as FavoriIdsSuccessState<Immersion>);
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
    store.dispatch(FavoriUpdateRequestAction<Immersion>("17", FavoriStatus.added));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.immersionFavorisIdsState as FavoriIdsSuccessState<Immersion>);
    expect(favorisState.favoriIds, {"1", "2", "4", "17"});
  });

  test("favori id list should be updated when favori is added and recheche result is null", () async {
    // Given
    final Store<AppState> store = _successStoreWithFavorisAndImmersionDetailsSuccessState();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.LOADING);
    final successState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.SUCCESS);

    // When
    store.dispatch(FavoriUpdateRequestAction<Immersion>("17", FavoriStatus.added));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.immersionFavorisIdsState as FavoriIdsSuccessState<Immersion>);
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
    store.dispatch(FavoriUpdateRequestAction<Immersion>("17", FavoriStatus.added));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.immersionFavorisIdsState as FavoriIdsSuccessState<Immersion>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
  });
}

Store<AppState> _successStoreWithFavorisAndSearchResultsLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.immersionFavorisRepository = ImmersionFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = MockAuthenticator.successful();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState()
        .copyWith(
            loginState: successMiloUserState(),
            immersionFavorisIdsState: FavoriIdsState<Immersion>.success({"1", "2", "4"}))
        .favoriListSuccessState([mockFavori('1'), mockFavori('2'), mockFavori('4')]) //
        .successRechercheImmersionState(results: [mockImmersion(id: '1'), mockImmersion(id: '17')]),
  );
  return store;
}

Store<AppState> _successStoreWithFavorisAndImmersionDetailsSuccessState() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.immersionFavorisRepository = ImmersionFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = MockAuthenticator.successful();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      rechercheImmersionState: RechercheImmersionState.initial(),
      immersionDetailsState: ImmersionDetailsSuccessState(mockImmersionDetails()),
      loginState: successMiloUserState(),
      immersionFavorisIdsState: FavoriIdsState<Immersion>.success({"2", "4"}),
    ),
  );
  return store;
}

Store<AppState> _failureStoreWithFavorisLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.immersionFavorisRepository = ImmersionFavorisRepositoryFailureStub();
  testStoreFactory.authenticator = MockAuthenticator.successful();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState()
        .copyWith(
            loginState: successMiloUserState(),
            immersionFavorisIdsState: FavoriIdsState<Immersion>.success({"1", "2", "4"}))
        .successRechercheImmersionState(results: [mockImmersion(id: '1'), mockImmersion(id: '17')]),
  );
  return store;
}

class ImmersionFavorisRepositorySuccessStub extends ImmersionFavorisRepository {
  ImmersionFavorisRepositorySuccessStub() : super(DioMock());

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
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
  ImmersionFavorisRepositoryFailureStub() : super(DioMock());

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    return {"1", "2", "4"};
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
