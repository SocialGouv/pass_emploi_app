import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/conseiller.dart';

class Rendezvous extends Equatable {
  final String id;
  final DateTime date;
  final bool isInVisio;
  final bool withConseiller;
  final bool isAnnule;
  final RendezvousType type;
  final String? modality;
  final int? duration;
  final String? comment;
  final String? organism;
  final String? address;
  final String? phone;
  final String? visioRedirectUrl;
  final String? theme;
  final String? description;
  final String? precision;
  final Conseiller? conseiller;

  Rendezvous({
    required this.id,
    required this.date,
    required this.isInVisio,
    required this.withConseiller,
    required this.isAnnule,
    required this.type,
    this.modality,
    this.duration,
    this.comment,
    this.organism,
    this.address,
    this.phone,
    this.visioRedirectUrl,
    this.theme,
    this.description,
    this.precision,
    this.conseiller,
  });

  @override
  List<Object?> get props {
    return [
      id,
      date,
      duration,
      isInVisio,
      modality,
      withConseiller,
      isAnnule,
      type,
      comment,
      organism,
      address,
      phone,
      visioRedirectUrl,
      theme,
      description,
      precision,
      conseiller,
    ];
  }
}

class RendezvousType extends Equatable {
  final RendezvousTypeCode code;
  final String label;

  const RendezvousType(this.code, this.label);

  @override
  List<Object?> get props => [code, label];
}

enum RendezvousTypeCode {
  ACTIVITE_EXTERIEURES,
  ATELIER,
  ENTRETIEN_INDIVIDUEL_CONSEILLER,
  ENTRETIEN_PARTENAIRE,
  INFORMATION_COLLECTIVE,
  VISITE,
  PRESTATION,
  AUTRE,
}
