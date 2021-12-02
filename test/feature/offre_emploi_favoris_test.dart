import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_id_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_update_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/src/store.dart';

import '../doubles/dummies.dart';
import '../utils/test_setup.dart';

main() {
  test("favoris id should be loaded at app startup when logged in", () async {
    // Given
    final Store<AppState> store = _successStore();

    final successState =
        store.onChange.firstWhere((element) => element.offreEmploiFavorisIdState is OffreEmploiFavorisIdLoadedState);

    // When
    store.dispatch(BootstrapAction());

    // Then
    final loadedFavoris = await successState;
    final favorisState = (loadedFavoris.offreEmploiFavorisIdState as OffreEmploiFavorisIdLoadedState);
    expect(favorisState.offreEmploiFavorisListId, ["1", "2", "4"]);
  });

  test("favori state should be updated when favori is removed and api call succeeds", () async {
    // Given
    final Store<AppState> store = _successStoreWithFavorisLoaded();

    final loadingState = store.onChange.any((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["1"] == OffreEmploiFavorisUpdateStatus.LOADING);
    final successState = store.onChange.firstWhere((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["1"] == OffreEmploiFavorisUpdateStatus.SUCCESS);

    // When
    store.dispatch(OffreEmploiRequestUpdateFavoriAction("1", false));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.offreEmploiFavorisIdState as OffreEmploiFavorisIdLoadedState);
    expect(favorisState.offreEmploiFavorisListId, ["2", "4"]);
  });

  test("favori state should not be updated when favori is removed and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState = store.onChange.any((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["1"] == OffreEmploiFavorisUpdateStatus.LOADING);
    final failureState = store.onChange.firstWhere((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["1"] == OffreEmploiFavorisUpdateStatus.ERROR);

    // When
    store.dispatch(OffreEmploiRequestUpdateFavoriAction("1", false));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.offreEmploiFavorisIdState as OffreEmploiFavorisIdLoadedState);
    expect(favorisState.offreEmploiFavorisListId, ["1", "2", "4"]);
  });

  test("favori state should be updated when favori is added and api call succeeds", () async {
    // Given
    Store<AppState> store = _successStoreWithFavorisLoaded();

    final loadingState = store.onChange.any((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["17"] == OffreEmploiFavorisUpdateStatus.LOADING);
    final successState = store.onChange.firstWhere((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["17"] == OffreEmploiFavorisUpdateStatus.SUCCESS);

    // When
    store.dispatch(OffreEmploiRequestUpdateFavoriAction("17", true));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await successState;
    final favorisState = (updatedFavoris.offreEmploiFavorisIdState as OffreEmploiFavorisIdLoadedState);
    expect(favorisState.offreEmploiFavorisListId, ["1", "2", "4", "17"]);
  });

  test("favori state should be updated when favori is added and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithFavorisLoaded();

    final loadingState = store.onChange.any((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["17"] == OffreEmploiFavorisUpdateStatus.LOADING);
    final failureState = store.onChange.firstWhere((element) =>
        element.offreEmploiFavorisUpdateState.requestStatus["17"] == OffreEmploiFavorisUpdateStatus.ERROR);

    // When
    store.dispatch(OffreEmploiRequestUpdateFavoriAction("17", true));

    // Then
    expect(await loadingState, true);
    final updatedFavoris = await failureState;
    final favorisState = (updatedFavoris.offreEmploiFavorisIdState as OffreEmploiFavorisIdLoadedState);
    expect(favorisState.offreEmploiFavorisListId, ["1", "2", "4"]);
  });
}

Store<AppState> _successStore() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
  testStoreFactory.userRepository = UserRepositoryLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
      loginState: LoginState.loggedIn(User(
        id: "id",
        firstName: "F",
        lastName: "L",
      )),
    ),
  );
  return store;
}

Store<AppState> _successStoreWithFavorisLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
  testStoreFactory.userRepository = UserRepositoryLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
        loginState: LoginState.loggedIn(User(
          id: "id",
          firstName: "F",
          lastName: "L",
        )),
        offreEmploiFavorisIdState: OffreEmploiFavorisIdState.idsLoaded(["1", "2", "4"])),
  );
  return store;
}

Store<AppState> _failureStoreWithFavorisLoaded() {
  final testStoreFactory = TestStoreFactory();
  testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositoryFailureStub();
  testStoreFactory.userRepository = UserRepositoryLoggedInStub();
  final store = testStoreFactory.initializeReduxStore(
    initialState: AppState.initialState().copyWith(
        loginState: LoginState.loggedIn(User(
          id: "id",
          firstName: "F",
          lastName: "L",
        )),
        offreEmploiFavorisIdState: OffreEmploiFavorisIdState.idsLoaded(["1", "2", "4"])),
  );
  return store;
}

class OffreEmploiFavorisRepositorySuccessStub extends OffreEmploiFavorisRepository {
  OffreEmploiFavorisRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  Future<List<String>?> getOffreEmploiFavorisId(String userId) async {
    return ["1", "2", "4"];
  }

  Future<bool> updateOffreEmploiFavoriStatus(String userId, String offreId, bool newStatus) async {
    return true;
  }
}

class OffreEmploiFavorisRepositoryFailureStub extends OffreEmploiFavorisRepository {
  OffreEmploiFavorisRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  Future<List<String>?> getOffreEmploiFavorisId(String userId) async {
    return ["1", "2", "4"];
  }

  Future<bool> updateOffreEmploiFavoriStatus(String userId, String offreId, bool newStatus) async {
    return false;
  }
}

class UserRepositoryLoggedInStub extends UserRepository {
  UserRepositoryLoggedInStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  Future<User?> getUser() async {
    return User(id: "id", firstName: "F", lastName: "L");
  }
}
