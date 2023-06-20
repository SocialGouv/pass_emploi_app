import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activites_state.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_actions.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_state.dart';
import 'package:pass_emploi_app/models/partage_activite.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/dummies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("partage activite state should be updated when user change preferences and api call succeeds", () async {
    // Given
    final Store<AppState> store = _successStoreWithLoadedPartageActivite();

    final loadingState = store.onChange.any((e) => e.partageActiviteUpdateState is PartageActiviteUpdateLoadingState);
    final successState =
        store.onChange.firstWhere((e) => e.partageActiviteUpdateState is PartageActiviteUpdateSuccessState);

    // When
    store.dispatch(PartageActiviteUpdateRequestAction(true));

    // Then
    expect(await loadingState, true);
    final updatedPreferences = await successState;
    final preferencesState = (updatedPreferences.partageActiviteUpdateState as PartageActiviteUpdateSuccessState);
    expect(preferencesState.favorisShared, true);
  });

  test("partage activite state should not be updated when user change preferences and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithLoadedPartageActivite();

    final loadingState = store.onChange.any((e) => e.partageActiviteUpdateState is PartageActiviteUpdateLoadingState);
    final failureState =
        store.onChange.firstWhere((e) => e.partageActiviteUpdateState is PartageActiviteUpdateFailureState);

    // When
    store.dispatch(PartageActiviteUpdateRequestAction(true));

    // Then
    expect(await loadingState, true);
    final updatedPreferences = await failureState;
    expect(updatedPreferences.partageActiviteUpdateState, isA<PartageActiviteUpdateFailureState>());
  });
}

Store<AppState> _successStoreWithLoadedPartageActivite() {
  final store = givenState()
      .loggedInMiloUser()
      .copyWith(partageActiviteState: PartageActiviteSuccessState(PartageActivite(partageFavoris: false)))
      .store((factory) => {factory.partageActiviteRepository = PartageActiviteRepositorySuccessStub()});

  return store;
}

Store<AppState> _failureStoreWithLoadedPartageActivite() {
  final store = givenState()
      .loggedInMiloUser()
      .copyWith(partageActiviteState: PartageActiviteSuccessState(PartageActivite(partageFavoris: false)))
      .store((factory) => {factory.partageActiviteRepository = PartageActiviteRepositoryFailureStub()});

  return store;
}

class PartageActiviteRepositorySuccessStub extends PartageActiviteRepository {
  PartageActiviteRepositorySuccessStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<bool> updatePartageActivite(String userId, bool isShare) async {
    return true;
  }
}

class PartageActiviteRepositoryFailureStub extends PartageActiviteRepository {
  PartageActiviteRepositoryFailureStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<bool> updatePartageActivite(String userId, bool isShare) async {
    return false;
  }
}
