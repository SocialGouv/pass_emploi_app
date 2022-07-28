import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/share_preferences/share_preferences_actions.dart';
import 'package:pass_emploi_app/features/share_preferences/share_preferences_state.dart';
import 'package:pass_emploi_app/models/share_preferences.dart';
import 'package:pass_emploi_app/repositories/share_preferences_repository.dart';

import '../../doubles/dummies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("share preferences should be fetched and displayed when screen loads", () async {
    // Given

    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.sharePreferencesRepository = SharePreferencesRepositorySuccessStub()});

    final displayedLoading = store.onChange.any((e) => e.sharePreferencesState is SharePreferencesLoadingState);
    final successState = store.onChange.firstWhere((e) => e.sharePreferencesState is SharePreferencesSuccessState);

    // When
    store.dispatch(SharePreferencesRequestAction());

    // Then
    expect(await displayedLoading, true);
    final appState = await successState;
    expect((appState.sharePreferencesState as SharePreferencesSuccessState).preferences.shareFavoris, true);
  });

  test("share preferences should be loaded and error displayed when repository returns null", () async {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.sharePreferencesRepository = SharePreferencesRepositoryFailureStub()});

    final displayedLoading = store.onChange.any((e) => e.sharePreferencesState is SharePreferencesLoadingState);
    final displayedError = store.onChange.any((e) => e.sharePreferencesState is SharePreferencesFailureState);

    // When
    store.dispatch(SharePreferencesRequestAction());

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });
}

class SharePreferencesRepositorySuccessStub extends SharePreferencesRepository {
  SharePreferencesRepositorySuccessStub() : super("", DummyHttpClient(), DummyPassEmploiCacheManager());

  @override
  Future<SharePreferences?> getSharePreferences(String userId) async {
    return SharePreferences(shareFavoris: true);
  }
}

class SharePreferencesRepositoryFailureStub extends SharePreferencesRepository {
  SharePreferencesRepositoryFailureStub() : super("", DummyHttpClient(), DummyPassEmploiCacheManager());

  @override
  Future<SharePreferences?> getSharePreferences(String userId) async {
    return null;
  }
}