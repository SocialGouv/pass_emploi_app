import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/preferences/preferences_actions.dart';
import 'package:pass_emploi_app/features/preferences/preferences_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Preferences', () {
    final sut = StoreSut();
    final repository = MockPreferencesRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => PreferencesRequestAction());

      test('should load then succeed when request succeeds', () {
        when(() => repository.getPreferences('id')).thenAnswer((_) async => mockPreferences(partageFavoris: true));

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.preferencesRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.getPreferences('id')).thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.preferencesRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<PreferencesLoadingState>((state) => state.preferencesState);

Matcher _shouldFail() => StateIs<PreferencesFailureState>((state) => state.preferencesState);

Matcher _shouldSucceed() {
  return StateIs<PreferencesSuccessState>(
    (state) => state.preferencesState,
    (state) => expect(state.preferences.partageFavoris, true),
  );
}
