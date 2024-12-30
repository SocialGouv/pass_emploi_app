import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/date_consultation_notification/date_consultation_notification_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/in_app_notification.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/notifications_center/notifications_center_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/expects.dart';

void main() {
  group('NotificationsCenterViewModel', () {
    test('should dispatch request action on retry', () {
      // Given
      final store = givenState() //
          .loggedInMiloUser()
          .withInAppNotificationsSuccess([]).spyStore();
      final viewModel = NotificationsCenterViewModel.create(store);

      // When
      viewModel.retry();

      // Then
      expectTypeThen<InAppNotificationsRequestAction>(store.dispatchedAction, (action) {
        expect(action, isA<InAppNotificationsRequestAction>());
      });
    });

    group('Display state', () {
      test('should display loader when in app notifications state is not initialized', () {
        // Given
        final store = givenState().loggedInMiloUser().withInAppNotificationsNotInitialized().store();

        // When
        final viewModel = NotificationsCenterViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('should display loader when in app notifications state is loading', () {
        // Given
        final store = givenState().loggedInMiloUser().withInAppNotificationsLoading().store();

        // When
        final viewModel = NotificationsCenterViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('should display content when in app notifications state is success', () {
        // Given
        final store = givenState() //
            .loggedInMiloUser()
            .withInAppNotificationsSuccess([mockInAppNotification()]).store();

        // When
        final viewModel = NotificationsCenterViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
      });

      test('should display empty placeholder when in app notifications state is success with 0 notification', () {
        // Given
        final store = givenState() //
            .loggedInMiloUser()
            .withInAppNotificationsSuccess([]).store();

        // When
        final viewModel = NotificationsCenterViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.EMPTY);
      });

      test('should display failure when in app notifications state is failure', () {
        // Given
        final store = givenState() //
            .loggedInMiloUser()
            .withInAppNotificationsFailure()
            .store();

        // When
        final viewModel = NotificationsCenterViewModel.create(store);

        // Then
        expect(viewModel.displayState, DisplayState.FAILURE);
      });
    });

    group('notifications', () {
      test('should display notifications for yesterday', () {
        // Given
        final yesterday = DateTime.now().subtract(Duration(days: 1));
        final store = givenState() //
            .loggedInMiloUser()
            .withInAppNotificationsSuccess([mockInAppNotification(date: yesterday)]).store();

        // When
        final viewModel = NotificationsCenterViewModel.create(store);

        // Then
        expect(viewModel.notifications, [
          NotificationViewModel(
            isNew: true,
            title: "Titre de la notification",
            description: "Description de la notification",
            date: "Hier",
          )
        ]);
      });

      test('should display notifications for previous date', () {
        // Given
        final yesterday = DateTime(2024);
        final store = givenState() //
            .loggedInMiloUser()
            .withInAppNotificationsSuccess([mockInAppNotification(date: yesterday)]).store();

        // When
        final viewModel = NotificationsCenterViewModel.create(store);

        // Then
        expect(viewModel.notifications, [
          NotificationViewModel(
            isNew: true,
            title: "Titre de la notification",
            description: "Description de la notification",
            date: "01 janvier 2024",
          )
        ]);
      });

      test('should dispatch deeplink action on pressed for rendez vous modifié', () {
        // Given
        final store = givenState() //
            .loggedInMiloUser()
            .withInAppNotificationsSuccess(
                [mockInAppNotification(type: InAppNotificationType.updatedRendezvous)]).spyStore();
        final viewModel = NotificationsCenterViewModel.create(store);

        // When
        viewModel.notifications.first.onPressed!();

        // Then
        expectTypeThen<HandleDeepLinkAction>(store.dispatchedAction, (action) {
          expect(action.deepLink, isA<RendezvousDeepLink>());
        });
      });

      test('should dispatch deeplink action on pressed for new rendez vous', () {
        // Given
        final store = givenState() //
            .loggedInMiloUser()
            .withInAppNotificationsSuccess(
                [mockInAppNotification(type: InAppNotificationType.newRendezvous)]).spyStore();
        final viewModel = NotificationsCenterViewModel.create(store);

        // When
        viewModel.notifications.first.onPressed!();

        // Then
        expectTypeThen<HandleDeepLinkAction>(store.dispatchedAction, (action) {
          expect(action.deepLink, isA<RendezvousDeepLink>());
        });
      });

      group('is new', () {
        test('should be new when date notification is after last consultation date', () {
          // Given
          final yesterday = DateTime(2024);
          final store = givenState() //
              .loggedInMiloUser()
              .copyWith(dateConsultationNotificationState: DateConsultationNotificationState(date: DateTime(1997)))
              .withInAppNotificationsSuccess([mockInAppNotification(date: yesterday)]).store();

          // When
          final viewModel = NotificationsCenterViewModel.create(store);

          // Then
          expect(viewModel.notifications, [
            NotificationViewModel(
              isNew: true,
              title: "Titre de la notification",
              description: "Description de la notification",
              date: "01 janvier 2024",
            )
          ]);
        });

        test('should not be new when date notification is before last consultation date', () {
          // Given
          final yesterday = DateTime(2024);
          final store = givenState() //
              .loggedInMiloUser()
              .copyWith(dateConsultationNotificationState: DateConsultationNotificationState(date: DateTime(2025)))
              .withInAppNotificationsSuccess([mockInAppNotification(date: yesterday)]).store();

          // When
          final viewModel = NotificationsCenterViewModel.create(store);

          // Then
          expect(viewModel.notifications, [
            NotificationViewModel(
              isNew: false,
              title: "Titre de la notification",
              description: "Description de la notification",
              date: "01 janvier 2024",
            )
          ]);
        });
      });
    });
  });
}
