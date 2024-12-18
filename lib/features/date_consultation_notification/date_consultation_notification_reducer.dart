import 'package:pass_emploi_app/features/date_consultation_notification/date_consultation_notification_actions.dart';
import 'package:pass_emploi_app/features/date_consultation_notification/date_consultation_notification_state.dart';

DateConsultationNotificationState dateConsultationNotificationReducer(
    DateConsultationNotificationState current, dynamic action) {
  if (action is DateConsultationNotificationSuccessAction) {
    return DateConsultationNotificationState(date: action.result);
  }
  return current;
}
