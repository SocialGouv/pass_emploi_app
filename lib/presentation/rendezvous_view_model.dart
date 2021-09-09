import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class RendezvousViewModel {
  final String title;
  final String subtitle;
  final String dateAndHour;
  final String dateWithoutHour;
  final String hourAndDuration;
  final String modality;
  final bool withComment;
  final String comment;

  RendezvousViewModel({
    required this.title,
    required this.subtitle,
    required this.dateAndHour,
    required this.dateWithoutHour,
    required this.hourAndDuration,
    required this.modality,
    required this.withComment,
    required this.comment,
  });

  factory RendezvousViewModel.create(Rendezvous rdv) {
    return RendezvousViewModel(
      title: rdv.title,
      subtitle: rdv.subtitle,
      dateAndHour: rdv.date.toDayAndHour(),
      dateWithoutHour: rdv.date.toDayWithFullMonth(),
      hourAndDuration: "${rdv.date.toHour()} (${_toDuration(rdv.duration)})",
      modality: 'Le rendez-vous se fera ${rdv.modality.toLowerCase()}.',
      withComment: rdv.comment.isNotEmpty,
      comment: rdv.comment,
    );
  }
}

_toDuration(String duration) {
  final durationSplit = duration.split(':');
  final hours = durationSplit[0];
  final minutes = durationSplit[1];
  if (hours == '0') return '${minutes}min';
  if (minutes == '00') return '${hours}h';
  return '${hours}h$minutes';
}
