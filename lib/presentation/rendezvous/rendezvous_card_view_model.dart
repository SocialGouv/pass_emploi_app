import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_view_model_helper.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:redux/redux.dart';

class RendezvousCardViewModel extends Equatable {
  final String id;
  final String tag;
  final String date;
  final bool isInscrit;
  final bool isAnnule;
  final String? title;
  final String? subtitle;
  final bool greenTag;

  RendezvousCardViewModel({
    required this.id,
    required this.tag,
    required this.date,
    required this.isInscrit,
    required this.isAnnule,
    required this.title,
    required this.subtitle,
    required this.greenTag,
  });

  factory RendezvousCardViewModel.create(Store<AppState> store, RendezvousStateSource source, String rdvId) {
    final rdv = getRendezvous(store, source, rdvId);
    return RendezvousCardViewModel(
      id: rdv.id,
      tag: takeTypeLabelOrPrecision(rdv),
      date: rdv.date.toDayAndHourContextualized(),
      isInscrit: rdv.estInscrit ?? false,
      isAnnule: rdv.isAnnule,
      title: rdv.title,
      subtitle: _subtitle(rdv),
      greenTag: isRendezvousGreenTag(rdv),
    );
  }

  @override
  List<Object?> get props {
    return [id, tag, date, isInscrit, isAnnule, title, subtitle, greenTag];
  }
}

String? _subtitle(Rendezvous rdv) {
  if (rdv.modality == null) return null;
  final modality = rdv.modality!.firstLetterUpperCased();
  final conseiller = rdv.conseiller;
  final withConseiller = rdv.withConseiller;
  if (withConseiller != null && withConseiller && conseiller != null && !rdv.source.isMilo) {
    return Strings.rendezvousModalityCardMessage(modality, '${conseiller.firstName} ${conseiller.lastName}');
  }
  return modality;
}
