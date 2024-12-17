import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_actions.dart';
import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_state.dart';

InAppNotificationsState inAppNotificationsReducer(InAppNotificationsState current, dynamic action) {
  if (action is InAppNotificationsLoadingAction) return InAppNotificationsLoadingState();
  if (action is InAppNotificationsFailureAction) return InAppNotificationsFailureState();
  if (action is InAppNotificationsSuccessAction) return InAppNotificationsSuccessState(action.result);
  if (action is InAppNotificationsResetAction) return InAppNotificationsNotInitializedState();
  return current;
}
