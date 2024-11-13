class DateConsultationWriteOffreAction {
  final String offreId;

  DateConsultationWriteOffreAction(this.offreId);
}

class DateConsultationUpdateAction {
  final Map<String, DateTime> offreIdToDateConsultation;

  DateConsultationUpdateAction(this.offreIdToDateConsultation);
}
