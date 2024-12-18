class DateConsultationNotificationRequestAction {}

class DateConsultationNotificationSuccessAction {
  final DateTime? result;

  DateConsultationNotificationSuccessAction(this.result);
}

class DateConsultationNotificationWriteAction {
  final DateTime date;

  DateConsultationNotificationWriteAction(this.date);
}
