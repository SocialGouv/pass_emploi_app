import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/preferences/preferences_state.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_actions.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/preferences_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

// TODO-GAD refactor test
void main() {
  test("partage activite state should be updated when user change preferences and api call succeeds", () async {
    // Given
    final Store<AppState> store = _successStoreWithLoadedPartageActivite();

    final loadingState = store.onChange.any((e) => e.preferencesUpdateState is PreferencesUpdateLoadingState);
    final successState = store.onChange.firstWhere((e) => e.preferencesUpdateState is PreferencesUpdateSuccessState);

    // When
    store.dispatch(PreferencesUpdateRequestAction(true));

    // Then
    expect(await loadingState, true);
    final updatedPreferences = await successState;
    final preferencesState = (updatedPreferences.preferencesUpdateState as PreferencesUpdateSuccessState);
    expect(preferencesState.favorisShared, true);
  });

  test("partage activite state should not be updated when user change preferences and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithLoadedPartageActivite();

    final loadingState = store.onChange.any((e) => e.preferencesUpdateState is PreferencesUpdateLoadingState);
    final failureState = store.onChange.firstWhere((e) => e.preferencesUpdateState is PreferencesUpdateFailureState);

    // When
    store.dispatch(PreferencesUpdateRequestAction(true));

    // Then
    expect(await loadingState, true);
    final updatedPreferences = await failureState;
    expect(updatedPreferences.preferencesUpdateState, isA<PreferencesUpdateFailureState>());
  });
}

Store<AppState> _successStoreWithLoadedPartageActivite() {
  final store = givenState()
      .loggedInMiloUser()
      .copyWith(preferencesState: PreferencesSuccessState(mockPreferences(partageFavoris: false)))
      .store((factory) => {factory.preferencesRepository = PartageActiviteRepositorySuccessStub()});

  return store;
}

Store<AppState> _failureStoreWithLoadedPartageActivite() {
  final store = givenState()
      .loggedInMiloUser()
      .copyWith(preferencesState: PreferencesSuccessState(mockPreferences(partageFavoris: false)))
      .store((factory) => {factory.preferencesRepository = PartageActiviteRepositoryFailureStub()});

  return store;
}

class PartageActiviteRepositorySuccessStub extends PreferencesRepository {
  PartageActiviteRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool> updatePreferences(String userId, bool isShare) async {
    return true;
  }
}

class PartageActiviteRepositoryFailureStub extends PreferencesRepository {
  PartageActiviteRepositoryFailureStub() : super(DioMock());

  @override
  Future<bool> updatePreferences(String userId, bool isShare) async {
    return false;
  }
}
