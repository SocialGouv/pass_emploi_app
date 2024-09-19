import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/notifications_settings/notifications_settings_actions.dart';
import 'package:pass_emploi_app/features/preferences/preferences_actions.dart';
import 'package:pass_emploi_app/features/preferences/preferences_state.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_actions.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/preferences/notification_preferences_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('NotificationPreferencesViewModel', () {
    group('displayState', () {
      test('should display loading when preferences state is loading', () {
        // Given
        final store = givenState().copyWith(preferencesState: PreferencesLoadingState()).store();

        // When
        final viewModel = NotificationPreferencesViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('should display failure when preferences state is failure', () {
        // Given
        final store = givenState().copyWith(preferencesState: PreferencesFailureState()).store();

        // When
        final viewModel = NotificationPreferencesViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.FAILURE);
      });

      test('should display content when preferences state is success', () {
        // Given
        final store = givenState().copyWith(preferencesState: PreferencesSuccessState(mockPreferences())).store();

        // When
        final viewModel = NotificationPreferencesViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
      });
    });

    test('should display error when update fails', () {
      // Given
      final store = givenState().copyWith(preferencesUpdateState: PreferencesUpdateFailureState()).store();

      // When
      final viewModel = NotificationPreferencesViewModel.create(store);

      // Then
      expect(viewModel.withUpdateError, true);
    });

    test('open app settings', () {
      // Given
      final store = StoreSpy();
      final viewModel = NotificationPreferencesViewModel.create(store);

      // When
      viewModel.onOpenAppSettings();

      // Then
      expect(store.dispatchedAction, isA<NotificationsSettingsRequestAction>());
    });

    test('retry', () {
      // Given
      final store = StoreSpy();
      final viewModel = NotificationPreferencesViewModel.create(store);

      // When
      viewModel.retry();

      // Then
      expect(store.dispatchedAction, isA<PreferencesRequestAction>());
    });

    test('should display preferences', () {
      // Given
      final store = givenState()
          .copyWith(
            preferencesState: PreferencesSuccessState(
              mockPreferences(
                pushNotificationAlertesOffres: true,
                pushNotificationCreationActionConseiller: true,
                pushNotificationRendezVousSessions: false,
                pushNotificationRappelActions: true,
              ),
            ),
          )
          .store();

      // When
      final viewModel = NotificationPreferencesViewModel.create(store);

      // Then
      expect(viewModel.withAlertesOffres, true);
      expect(viewModel.withCreationAction, true);
      expect(viewModel.withRendezvousSessions, false);
      expect(viewModel.withRappelActions, true);
    });

    test('should display Cej wording when accompagnement is Cej', () {
      // Given
      final store = givenState().loggedInMiloUser().store();

      // When
      final viewModel = NotificationPreferencesViewModel.create(store);

      // Then
      expect(viewModel.withMiloWording, true);
    });

    test('should not display Cej wording when accompagnement is not Cej', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().store();

      // When
      final viewModel = NotificationPreferencesViewModel.create(store);

      // Then
      expect(viewModel.withMiloWording, false);
    });

    test('on AlertesOffres changed should dispatch update preferences action', () {
      // Given
      final store = StoreSpy();
      final viewModel = NotificationPreferencesViewModel.create(store);

      // When
      viewModel.onAlertesOffresChanged(true);

      // Then
      expect(store.dispatchedAction, isA<PreferencesUpdateRequestAction>());
      expect((store.dispatchedAction as PreferencesUpdateRequestAction).pushNotificationAlertesOffres, true);
    });

    test('on CreationAction changed should dispatch update preferences action', () {
      // Given
      final store = StoreSpy();
      final viewModel = NotificationPreferencesViewModel.create(store);

      // When
      viewModel.onCreationActionChanged(true);

      // Then
      expect(store.dispatchedAction, isA<PreferencesUpdateRequestAction>());
      expect((store.dispatchedAction as PreferencesUpdateRequestAction).pushNotificationCreationAction, true);
    });

    test('on RendezvousSessions changed should dispatch update preferences action', () {
      // Given
      final store = StoreSpy();
      final viewModel = NotificationPreferencesViewModel.create(store);

      // When
      viewModel.onRendezvousSessionsChanged(true);

      // Then
      expect(store.dispatchedAction, isA<PreferencesUpdateRequestAction>());
      expect((store.dispatchedAction as PreferencesUpdateRequestAction).pushNotificationRendezvousSessions, true);
    });

    test('on RappelActions changed should dispatch update preferences action', () {
      // Given
      final store = StoreSpy();
      final viewModel = NotificationPreferencesViewModel.create(store);

      // When
      viewModel.onRappelActionsChanged(true);

      // Then
      expect(store.dispatchedAction, isA<PreferencesUpdateRequestAction>());
      expect((store.dispatchedAction as PreferencesUpdateRequestAction).pushNotificationRappelActions, true);
    });
  });
}
