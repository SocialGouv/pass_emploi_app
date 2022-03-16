import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_extensions.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class RendezvousCardViewModel extends Equatable {
  final String id;
  final String tag;
  final String date;
  final String? title;
  final String subtitle;

  RendezvousCardViewModel({
    required this.id,
    required this.tag,
    required this.date,
    required this.title,
    required this.subtitle,
  });

  factory RendezvousCardViewModel.create(Rendezvous rdv) {
    return RendezvousCardViewModel(
      id: rdv.id,
      tag: rdv.takeTypeLabelOrPrecision(),
      date: rdv.date.toDayAndHourContextualized(),
      title: rdv.organism != null ? Strings.withOrganism(rdv.organism!) : null,
      subtitle: _modalityFirstLetterUpperCased(rdv),
    );
  }

  @override
  List<Object?> get props {
    return [id, tag, date, title, subtitle];
  }
}

String _modalityFirstLetterUpperCased(Rendezvous rdv) {
  if (rdv.modality.length > 1) return rdv.modality.substring(0, 1).toUpperCase() + rdv.modality.substring(1);
  return rdv.modality;
}
