import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/preferences/preferences_actions.dart';
import 'package:pass_emploi_app/features/preferences/preferences_state.dart';
import 'package:pass_emploi_app/models/preferences.dart';
import 'package:pass_emploi_app/repositories/preferences_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("PartageActivite should be fetched and displayed when screen loads", () async {
    // Given

    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.preferencesRepository = PartageActiviteRepositorySuccessStub()});

    final displayedLoading = store.onChange.any((e) => e.preferencesState is PreferencesLoadingState);
    final successState = store.onChange.firstWhere((e) => e.preferencesState is PreferencesSuccessState);

    // When
    store.dispatch(PreferencesRequestAction());

    // Then
    expect(await displayedLoading, true);
    final appState = await successState;
    expect((appState.preferencesState as PreferencesSuccessState).preferences.partageFavoris, true);
  });

  test("PartageActivite should be loaded and error displayed when repository returns null", () async {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.preferencesRepository = PartageActiviteRepositoryFailureStub()});

    final displayedLoading = store.onChange.any((e) => e.preferencesState is PreferencesLoadingState);
    final displayedError = store.onChange.any((e) => e.preferencesState is PreferencesFailureState);

    // When
    store.dispatch(PreferencesRequestAction());

    // Then
    expect(await displayedLoading, true);
    expect(await displayedError, true);
  });
}

// TODO- GAD refactor test
class PartageActiviteRepositorySuccessStub extends PreferencesRepository {
  PartageActiviteRepositorySuccessStub() : super(DioMock());

  @override
  Future<Preferences?> getPreferences(String userId) async {
    return mockPreferences(partageFavoris: true);
  }
}

class PartageActiviteRepositoryFailureStub extends PreferencesRepository {
  PartageActiviteRepositoryFailureStub() : super(DioMock());

  @override
  Future<Preferences?> getPreferences(String userId) async {
    return null;
  }
}
