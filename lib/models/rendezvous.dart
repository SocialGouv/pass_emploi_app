import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class Rendezvous extends Equatable {
  final String id;
  final DateTime date;
  final String title;
  final int duration;
  final String modality;
  final bool withConseiller;
  final RendezvousType type;
  final String? comment;
  final String? organism;
  final String? address;
  final String? precision;
  final Conseiller? conseiller;

  Rendezvous({
    required this.id,
    required this.date,
    required this.title,
    required this.duration,
    required this.modality,
    required this.withConseiller,
    required this.type,
    this.comment,
    this.organism,
    this.address,
    this.precision,
    this.conseiller,
  });

  factory Rendezvous.fromJson(dynamic json) {
    return Rendezvous(
      id: json['id'] as String,
      date: (json['date'] as String).toDateTimeUtcOnLocalTimeZone(),
      title: json['title'] as String,
      duration: json['duration'] as int,
      modality: json['modality'] as String,
      withConseiller: json['presenceConseiller'] as bool,
      type: RendezvousType.fromJson(json['type']),
      comment: json['comment'] as String?,
      organism: json['organisme'] as String?,
      address: json['adresse'] as String?,
      precision: json['precision'] as String?,
      conseiller: json['conseiller'] != null ? Conseiller.fromJson(json['conseiller']) : null,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      date,
      title,
      duration,
      modality,
      withConseiller,
      type,
      comment,
      organism,
      address,
      precision,
      conseiller,
    ];
  }
}

class RendezvousType extends Equatable {
  final RendezvousTypeCode code;
  final String label;

  RendezvousType(this.code, this.label);

  factory RendezvousType.fromJson(dynamic json) {
    return RendezvousType(
      _parseRendezvousTypeCode(json['code'] as String),
      json['label'] as String,
    );
  }

  @override
  List<Object?> get props => [code, label];

  static RendezvousTypeCode _parseRendezvousTypeCode(String rendezvousTypeCode) {
    return RendezvousTypeCode.values.firstWhere(
      (e) => e.name == rendezvousTypeCode,
      orElse: () => RendezvousTypeCode.AUTRE,
    );
  }
}

enum RendezvousTypeCode {
  ACTIVITE_EXTERIEURES,
  ATELIER,
  ENTRETIEN_INDIVIDUEL_CONSEILLER,
  ENTRETIEN_PARTENAIRE,
  INFORMATION_COLLECTIVE,
  VISITE,
  AUTRE,
}
