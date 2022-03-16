import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_extensions.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class RendezvousCardViewModel extends Equatable {
  final String id; // CARD
  final String tag; // CARD
  final String date; // CARD
  final String? title; // CARD
  final String subtitle; // CARD
  final String dateAndHour; // ???
  final String dateWithoutHour; // ???
  final String hourAndDuration; // ???
  final String modality; // ???
  final bool withComment; // ???
  final String comment; // ???

  RendezvousCardViewModel({
    required this.id,
    required this.tag,
    required this.date,
    required this.title,
    required this.subtitle,
    required this.dateAndHour,
    required this.dateWithoutHour,
    required this.hourAndDuration,
    required this.modality,
    required this.withComment,
    required this.comment,
  });

  factory RendezvousCardViewModel.create(Rendezvous rdv) {
    return RendezvousCardViewModel(
      id: rdv.id,
      tag: rdv.takeTypeLabelOrPrecision(),
      date: rdv.date.toDayAndHourContextualized(),
      title: rdv.organism != null ? Strings.withOrganism(rdv.organism!) : null,
      subtitle: rdv.modality,
      dateAndHour: rdv.date.toDayAndHourOld(),
      dateWithoutHour: rdv.date.toDayWithFullMonth(),
      hourAndDuration: "${rdv.date.toHour()} (${_toDuration(rdv.duration)})",
      modality: Strings.rendezVousModalityMessage(rdv.modality.toLowerCase()),
      withComment: rdv.comment?.isNotEmpty == true,
      comment: rdv.comment ?? '',
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      tag,
      date,
      title,
      subtitle,
      dateAndHour,
      dateWithoutHour,
      hourAndDuration,
      modality,
      withComment,
      comment,
    ];
  }
}

String _toDuration(int duration) {
  final hours = duration ~/ 60;
  final minutes = duration % 60;
  if (hours == 0) return '${minutes}min';
  if (minutes == 0) return '${hours}h';
  return '${hours}h$minutes';
}
