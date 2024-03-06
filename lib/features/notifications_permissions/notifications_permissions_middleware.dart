import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/notifications_permissions/notifications_permissions_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class NotificationsPermissionsMiddleware extends MiddlewareClass<AppState> {
  final PushNotificationManager _repository;

  NotificationsPermissionsMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is NotificationsPermissionsRequestAction || (Brand.isBrsa() && action is BootstrapAction)) {
      _repository.requestPermission();
    }
  }
}
