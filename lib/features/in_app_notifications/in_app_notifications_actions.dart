import 'package:pass_emploi_app/models/in_app_notification.dart';

class InAppNotificationsRequestAction {}

class InAppNotificationsLoadingAction {}

class InAppNotificationsSuccessAction {
  final List<InAppNotification> result;

  InAppNotificationsSuccessAction(this.result);
}

class InAppNotificationsFailureAction {}

class InAppNotificationsResetAction {}
