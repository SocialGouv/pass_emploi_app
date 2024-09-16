import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/preferences/preferences_state.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_actions.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_state.dart';
import 'package:pass_emploi_app/models/preferences.dart';
import 'package:pass_emploi_app/network/put_preferences_request.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Update preferences', () {
    final sut = StoreSut();
    final repository = MockPreferencesRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => PreferencesUpdateRequestAction(pushNotificationMessages: false));

      test('should load, update preferences locally then succeed when request succeeds', () {
        when(() => repository.updatePreferences('id', PutPreferencesRequest(pushNotificationMessages: false)))
            .thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedIn()
            .copyWith(
              preferencesState: PreferencesSuccessState(
                Preferences(
                  partageFavoris: true,
                  pushNotificationAlertesOffres: true,
                  pushNotificationMessages: true,
                  pushNotificationCreationAction: true,
                  pushNotificationRendezvousSessions: true,
                  pushNotificationRappelActions: true,
                ),
              ),
            )
            .store((f) => {f.preferencesRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldUpdatePreferencesLocallyThenSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.updatePreferences('id', PutPreferencesRequest(pushNotificationMessages: false)))
            .thenAnswer((_) async => false);

        sut.givenStore = givenState() //
            .loggedIn()
            .copyWith(
              preferencesState: PreferencesSuccessState(
                mockPreferences(),
              ),
            )
            .store((f) => {f.preferencesRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<PreferencesUpdateLoadingState>((state) => state.preferencesUpdateState);

Matcher _shouldFail() => StateIs<PreferencesUpdateFailureState>((state) => state.preferencesUpdateState);

Matcher _shouldUpdatePreferencesLocallyThenSucceed() {
  return StateMatch(
    (state) => state.preferencesUpdateState is PreferencesUpdateSuccessState,
    (state) => expect(
      (state.preferencesState as PreferencesSuccessState).preferences,
      Preferences(
        partageFavoris: true,
        pushNotificationAlertesOffres: true,
        pushNotificationMessages: false,
        pushNotificationCreationAction: true,
        pushNotificationRendezvousSessions: true,
        pushNotificationRappelActions: true,
      ),
    ),
  );
}
