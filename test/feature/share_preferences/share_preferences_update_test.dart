import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/share_preferences/share_preferences_state.dart';
import 'package:pass_emploi_app/features/share_preferences/update/share_preferences_update_actions.dart';
import 'package:pass_emploi_app/features/share_preferences/update/share_preferences_update_state.dart';
import 'package:pass_emploi_app/models/share_preferences.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/share_preferences_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dummies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {

  test("share preferences state should be updated when user change preferences and api call succeeds", () async {
    // Given
    final Store<AppState> store = _successStoreWithLoadedSharePreferences();

    final loadingState = store.onChange.any((e) => e.sharePreferencesUpdateState is SharePreferencesUpdateLoadingState);
    final successState =
        store.onChange.firstWhere((e) => e.sharePreferencesUpdateState is SharePreferencesUpdateSuccessState);

    // When
    store.dispatch(SharePreferencesUpdateRequestAction(true));

    // Then
    expect(await loadingState, true);
    final updatedPreferences = await successState;
    final preferencesState = (updatedPreferences.sharePreferencesUpdateState as SharePreferencesUpdateSuccessState);
    expect(preferencesState.favorisShared, true);
  });

  test("share preferences state should not be updated when user change preferences and api call fails", () async {
    // Given
    final Store<AppState> store = _failureStoreWithLoadedSharePreferences();

    final loadingState = store.onChange.any((e) => e.sharePreferencesUpdateState is SharePreferencesUpdateLoadingState);
    final failureState =
        store.onChange.firstWhere((e) => e.sharePreferencesUpdateState is SharePreferencesUpdateFailureState);

    // When
    store.dispatch(SharePreferencesUpdateRequestAction(true));

    // Then
    expect(await loadingState, true);
    final updatedPreferences = await failureState;
    expect(updatedPreferences.sharePreferencesUpdateState, isA<SharePreferencesUpdateFailureState>());
  });
}

Store<AppState> _successStoreWithLoadedSharePreferences() {
  final store = givenState()
      .loggedInMiloUser()
      .copyWith(sharePreferencesState: SharePreferencesSuccessState(SharePreferences(shareFavoris: false)))
      .store((factory) => {factory.sharePreferencesRepository = SharePreferencesRepositorySuccessStub()});

  return store;
}

Store<AppState> _failureStoreWithLoadedSharePreferences() {
  final store = givenState()
      .loggedInMiloUser()
      .copyWith(sharePreferencesState: SharePreferencesSuccessState(SharePreferences(shareFavoris: false)))
      .store((factory) => {factory.sharePreferencesRepository = SharePreferencesRepositoryFailureStub()});

  return store;
}

class SharePreferencesRepositorySuccessStub extends SharePreferencesRepository {
  SharePreferencesRepositorySuccessStub() : super("", DummyHttpClient(), DummyPassEmploiCacheManager());

  @override
  Future<bool> updateSharePreferences(String userId, bool isShare) async {
    return true;
  }
}

class SharePreferencesRepositoryFailureStub extends SharePreferencesRepository {
  SharePreferencesRepositoryFailureStub() : super("", DummyHttpClient(), DummyPassEmploiCacheManager());

  @override
  Future<bool> updateSharePreferences(String userId, bool isShare) async {
    return false;
  }
}
