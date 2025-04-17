import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:redux/redux.dart';

enum InscriptionStatus { inscrit, notInscrit, autoinscription, hidden, full }

class RendezvousCardViewModel extends Equatable {
  final String id;
  final String tag;
  final String date;
  final String hourAndDuration;
  final InscriptionStatus inscriptionStatus;
  final bool isAnnule;
  final String title;
  final String? description;
  final String? nombreDePlacesRestantes;
  final String? place;
  final String? assetImage;

  RendezvousCardViewModel({
    required this.id,
    required this.tag,
    required this.date,
    required this.hourAndDuration,
    required this.inscriptionStatus,
    required this.isAnnule,
    required this.title,
    required this.description,
    required this.place,
    required this.nombreDePlacesRestantes,
    required this.assetImage,
  });

  factory RendezvousCardViewModel.create(Store<AppState> store, RendezvousStateSource source, String rdvId) {
    final rdv = store.getRendezvous(source, rdvId);
    return RendezvousCardViewModel(
      id: rdv.id,
      tag: rdv.type.label,
      date: rdv.date.toDayWithFullMonthContextualized(),
      hourAndDuration: _hours(rdv),
      inscriptionStatus: _inscription(rdv, source),
      isAnnule: rdv.isAnnule,
      title: rdv.title ?? '',
      description: rdv.precision,
      place: _place(rdv),
      nombreDePlacesRestantes: _nombreDePlacesRestantes(rdv, source),
      assetImage: _assetImage(rdv, source),
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      tag,
      date,
      hourAndDuration,
      inscriptionStatus,
      isAnnule,
      title,
      description,
      place,
      nombreDePlacesRestantes,
    ];
  }
}

InscriptionStatus _inscription(Rendezvous rdv, RendezvousStateSource source) {
  if (!source.isFromEvenements) return InscriptionStatus.hidden;

  if (rdv.estInscrit == true) return InscriptionStatus.inscrit;

  if (rdv.nombreDePlacesRestantes == 0) return InscriptionStatus.full;

  if (rdv.autoInscriptionAvailable) return InscriptionStatus.autoinscription;

  return InscriptionStatus.notInscrit;
}

String _hours(Rendezvous rdv) {
  final heureDebut = rdv.date.toHourWithHSeparator();
  final heureFin = rdv.duration != null && rdv.duration != 0
      ? rdv.date.add(Duration(minutes: rdv.duration!)).toHourWithHSeparator()
      : null;
  final period = "$heureDebut${heureFin != null ? " - $heureFin" : ""}";
  return period;
}

String? _place(Rendezvous rdv) {
  if (rdv.modality == null) return null;
  final modality = rdv.modality!.firstLetterUpperCased();
  final conseiller = rdv.conseiller;
  final withConseiller = rdv.withConseiller;
  if (withConseiller != null && withConseiller && conseiller != null && !rdv.source.isMilo) {
    return Strings.rendezvousModalityCardMessage(modality, '${conseiller.firstName} ${conseiller.lastName}');
  }
  return modality;
}

String? _nombreDePlacesRestantes(Rendezvous rdv, RendezvousStateSource source) {
  if (!source.isFromEvenements) return null;
  if (rdv.nombreDePlacesRestantes == null || rdv.nombreDePlacesRestantes == 0) return null;
  return Strings.placesRestantes(rdv.nombreDePlacesRestantes!);
}

String? _assetImage(Rendezvous rdv, RendezvousStateSource source) {
  final showImage = [
    RendezvousStateSource.eventListSessionsMilo,
  ].contains(source);
  if (!showImage) return null;
  return SessionMilo.themeIllustrationPath(rdv.theme);
}
