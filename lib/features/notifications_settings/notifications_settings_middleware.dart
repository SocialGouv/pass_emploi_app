import 'package:pass_emploi_app/features/notifications_settings/notifications_settings_actions.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class NotificationsSettingsMiddleware extends MiddlewareClass<AppState> {
  final PushNotificationManager manager;

  NotificationsSettingsMiddleware(this.manager);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is NotificationsSettingsRequestAction) {
      final hasBeenRequested = await manager.hasNotificationBeenRequested();
      if (!hasBeenRequested) {
        await manager.requestPermission();
      } else {
        await manager.openAppSettings();
      }
    }
  }
}
