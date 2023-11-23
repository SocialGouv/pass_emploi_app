import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_actions.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_state.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_state.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_delete_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  group("When repository succeeds…", () {
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.alerteDeleteRepository = AlerteDeleteRepositorySuccessStub();

    test("alerte should be deleted", () async {
      // Given
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());
      final displayedLoading = store.onChange.any((e) => e.alerteDeleteState is AlerteDeleteLoadingState);
      final successState = store.onChange.firstWhere((e) => e.alerteDeleteState is AlerteDeleteSuccessState);

      // When
      store.dispatch(AlerteDeleteRequestAction("alerteId"));

      // Then
      expect(await displayedLoading, isTrue);
      final appState = await successState;
      expect(appState.alerteDeleteState is AlerteDeleteSuccessState, isTrue);
    });

    test("alerte should be removed from alertes", () async {
      // Given
      final store = testStoreFactory.initializeReduxStore(
        initialState: loggedInState().copyWith(alerteListState: AlerteListSuccessState([_mockAlerte()])),
      );
      final displayedLoading = store.onChange.any((e) => e.alerteDeleteState is AlerteDeleteLoadingState);
      final successState = store.onChange.firstWhere((e) => e.alerteDeleteState is AlerteDeleteSuccessState);

      // When
      store.dispatch(AlerteDeleteRequestAction("alerteId"));

      // Then
      expect(await displayedLoading, isTrue);
      final appState = await successState;
      expect((appState.alerteListState as AlerteListSuccessState).alertes, isEmpty);
    });
  });

  group("When repository fails…", () {
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.alerteDeleteRepository = AlerteDeleteRepositoryFailureStub();

    test("alerte delete state should be failure", () async {
      // Given
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInState());
      final displayedLoading = store.onChange.any((e) => e.alerteDeleteState is AlerteDeleteLoadingState);
      final failureState = store.onChange.firstWhere((e) => e.alerteDeleteState is AlerteDeleteFailureState);

      // When
      store.dispatch(AlerteDeleteRequestAction("alerteId"));

      // Then
      expect(await displayedLoading, isTrue);
      final appState = await failureState;
      expect(appState.alerteDeleteState is AlerteDeleteFailureState, isTrue);
    });

    test("alerte should not be removed from alertes", () async {
      // Given
      final store = testStoreFactory.initializeReduxStore(
        initialState: loggedInState().copyWith(alerteListState: AlerteListSuccessState([_mockAlerte()])),
      );
      final displayedLoading = store.onChange.any((e) => e.alerteDeleteState is AlerteDeleteLoadingState);
      final failureState = store.onChange.firstWhere((e) => e.alerteDeleteState is AlerteDeleteFailureState);

      // When
      store.dispatch(AlerteDeleteRequestAction("alerteId"));

      // Then
      expect(await displayedLoading, isTrue);
      final appState = await failureState;
      expect((appState.alerteListState as AlerteListSuccessState).alertes, [_mockAlerte()]);
    });
  });
}

Alerte _mockAlerte() {
  return ImmersionAlerte(
    id: "alerteId",
    title: "",
    metier: "",
    location: mockLocation(),
    filtres: ImmersionFiltresRecherche.noFiltre(),
    ville: "",
    codeRome: "",
  );
}

class AlerteDeleteRepositorySuccessStub extends AlerteDeleteRepository {
  AlerteDeleteRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool> delete(String userId, String alerteId) async {
    if (userId == "id" && alerteId == "alerteId") return true;
    return false;
  }
}

class AlerteDeleteRepositoryFailureStub extends AlerteDeleteRepository {
  AlerteDeleteRepositoryFailureStub() : super(DioMock());

  @override
  Future<bool> delete(String userId, String alerteId) async => false;
}
