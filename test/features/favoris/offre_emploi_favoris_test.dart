import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
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
    store.dispatch(FavoriUpdateRequestAction<OffreEmploi>("1", FavoriStatus.removed));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final emploiFavorisState = (updatedFavoris.offreEmploiFavorisIdsState as FavoriIdsSuccessState<OffreEmploi>);
    expect(emploiFavorisState.favoris, {FavoriDto("2"), FavoriDto("4")});

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
    store.dispatch(FavoriUpdateRequestAction<OffreEmploi>("1", FavoriStatus.removed));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.offreEmploiFavorisIdsState as FavoriIdsSuccessState<OffreEmploi>);
    expect(favorisState.favoris, {FavoriDto("1"), FavoriDto("2"), FavoriDto("4")});
  });

  test("favori id list should be updated when favori is added and api call succeeds", () async {
    // Given
    final Store<AppState> store = _successStoreWithFavorisAndSearchResultsLoaded();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.LOADING);
    final successState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.SUCCESS);

    // When
    store.dispatch(FavoriUpdateRequestAction<OffreEmploi>("17", FavoriStatus.added));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.offreEmploiFavorisIdsState as FavoriIdsSuccessState<OffreEmploi>);
    expect(favorisState.favoris, {FavoriDto("1"), FavoriDto("2"), FavoriDto("4"), FavoriDto("17")});
  });

  test("favori id list should be updated when favori is added and recheche result is null", () async {
    // Given
    final Store<AppState> store = _successStoreWithFavorisAndOffreEmploiDetailsSuccessState();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.LOADING);
    final successState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.SUCCESS);

    // When
    store.dispatch(FavoriUpdateRequestAction<OffreEmploi>("17", FavoriStatus.added));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.offreEmploiFavorisIdsState as FavoriIdsSuccessState<OffreEmploi>);
    expect(favorisState.favoris, {FavoriDto("2"), FavoriDto("4"), FavoriDto("17")});
  });

  test("favori state should not be updated when favori is added and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState =
        store.onChange.any((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.LOADING);
    final failureState = store.onChange
        .firstWhere((element) => element.favoriUpdateState.requestStatus["17"] == FavoriUpdateStatus.ERROR);

    // When
    store.dispatch(FavoriUpdateRequestAction<OffreEmploi>("17", FavoriStatus.added));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.offreEmploiFavorisIdsState as FavoriIdsSuccessState<OffreEmploi>);
    expect(favorisState.favoris, {FavoriDto("1"), FavoriDto("2"), FavoriDto("4")});
  });
}

Store<AppState> _successStoreWithFavorisAndSearchResultsLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = MockAuthenticator.successful();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState()
        .copyWith(
            loginState: successMiloUserState(),
            offreEmploiFavorisIdsState:
                FavoriIdsState<OffreEmploi>.success({FavoriDto("1"), FavoriDto("2"), FavoriDto("4")}))
        .favoriListSuccessState([mockFavori('1'), mockFavori('2'), mockFavori('4')]) //
        .successRechercheEmploiState(results: [mockOffreEmploi(id: '1'), mockOffreEmploi(id: '17')]),
  );
  return store;
}

Store<AppState> _successStoreWithFavorisAndOffreEmploiDetailsSuccessState() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
  testStoreFactory.authenticator = MockAuthenticator.successful();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
        rechercheEmploiState: RechercheEmploiState.initial(),
        offreEmploiDetailsState: OffreEmploiDetailsSuccessState(mockOffreEmploiDetails()),
        loginState: successMiloUserState(),
        offreEmploiFavorisIdsState: FavoriIdsState<OffreEmploi>.success({FavoriDto("2"), FavoriDto("4")})),
  );
  return store;
}

Store<AppState> _failureStoreWithFavorisLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositoryFailureStub();
  testStoreFactory.authenticator = MockAuthenticator.successful();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState()
        .copyWith(
            loginState: successMiloUserState(),
            offreEmploiFavorisIdsState:
                FavoriIdsState<OffreEmploi>.success({FavoriDto("1"), FavoriDto("2"), FavoriDto("4")}))
        .successRechercheEmploiState(results: [mockOffreEmploi(id: '1'), mockOffreEmploi(id: '17')]),
  );
  return store;
}

class OffreEmploiFavorisRepositorySuccessStub extends OffreEmploiFavorisRepository {
  OffreEmploiFavorisRepositorySuccessStub() : super(DioMock());

  @override
  Future<Set<FavoriDto>?> getFavorisId(String userId) async {
    return {FavoriDto("1"), FavoriDto("2"), FavoriDto("4")};
  }

  @override
  Future<bool> postFavori(String userId, OffreEmploi offre, {bool postulated = false}) async {
    return true;
  }

  @override
  Future<bool> deleteFavori(String userId, String offreId) async {
    return true;
  }
}

class OffreEmploiFavorisRepositoryFailureStub extends OffreEmploiFavorisRepository {
  OffreEmploiFavorisRepositoryFailureStub() : super(DioMock());

  @override
  Future<Set<FavoriDto>?> getFavorisId(String userId) async {
    return {FavoriDto("1"), FavoriDto("2"), FavoriDto("4")};
  }

  @override
  Future<bool> postFavori(String userId, OffreEmploi offre, {bool postulated = false}) async {
    return false;
  }

  @override
  Future<bool> deleteFavori(String userId, String offreId) async {
    return false;
  }
}
