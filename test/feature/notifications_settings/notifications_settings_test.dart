import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/notifications_settings/notifications_settings_actions.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/sut_redux.dart';

void main() {
  late MockPushNotificationManager pushNotificationManager;

  setUp(() => pushNotificationManager = MockPushNotificationManager());
  group('NotificationsSettings', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.whenDispatchingAction(() => NotificationsSettingsRequestAction());
      test('when notification permission has never been requested should request permission', () async {
        sut.givenStore = givenState().store((f) => {
              f.pushNotificationManager = pushNotificationManager
                ..mockHasNotificationBeenRequested(false)
                ..mockRequestPermission(),
            });

        await sut.thenExpectNothing();
        verify(() => pushNotificationManager.requestPermission()).called(1);
        verifyNever(() => pushNotificationManager.openAppSettings());
      });

      test('when notification has already been requested should open device settings', () async {
        sut.givenStore = givenState().store((f) => {
              f.pushNotificationManager = pushNotificationManager
                ..mockHasNotificationBeenRequested(true)
                ..mockOpenAppSettings()
            });

        await sut.thenExpectNothing();
        verifyNever(() => pushNotificationManager.requestPermission());
        verify(() => pushNotificationManager.openAppSettings()).called(1);
      });
    });
  });
}
