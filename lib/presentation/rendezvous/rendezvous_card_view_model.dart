import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
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
  final String? title;
  final String subtitle;

  RendezvousCardViewModel({
    required this.id,
    required this.tag,
    required this.date,
    required this.title,
    required this.subtitle,
  });

  factory RendezvousCardViewModel.create(Store<AppState> store, String rdvId) {
    final rdv = getRendezvousFromStore(store, rdvId);
    return RendezvousCardViewModel(
      id: rdv.id,
      tag: takeTypeLabelOrPrecision(rdv),
      date: rdv.date.toDayAndHourContextualized(),
      title: rdv.organism != null ? Strings.withOrganism(rdv.organism!) : null,
      subtitle: _subtitle(rdv),
    );
  }

  @override
  List<Object?> get props {
    return [id, tag, date, title, subtitle];
  }
}

String _subtitle(Rendezvous rdv) {
  final modality = rdv.modality.firstLetterUpperCased();
  final conseiller = rdv.conseiller;
  if (rdv.withConseiller && conseiller != null) {
    return Strings.rendezvousModalityCardMessage(modality, '${conseiller.firstName} ${conseiller.lastName}');
  }
  return modality;
}
