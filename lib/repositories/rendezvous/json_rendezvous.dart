import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

const String _poleEmploiOrganism = 'Agence France Travail';

class JsonRendezvous {
  final String id;
  final RendezvousSource source;
  final String date;
  final bool isLocaleDate;
  final int duration;
  final String? modality;
  final bool? isInVisio;
  final bool? withConseiller;
  final bool? isAnnule;
  final RendezvousType type;
  final String? title;
  final String? comment;
  final String? organism;
  final bool? isInAgencePoleEmploi;
  final String? address;
  final String? phone;
  final String? visioRedirectUrl;
  final String? precision;
  final String? theme;
  final String? description;
  final Conseiller? conseiller;
  final Conseiller? createur;
  final bool? estInscrit;

  JsonRendezvous._({
    required this.id,
    required this.source,
    required this.date,
    required this.isLocaleDate,
    required this.duration,
    required this.modality,
    required this.isInVisio,
    required this.withConseiller,
    required this.isAnnule,
    required this.type,
    required this.title,
    required this.comment,
    required this.isInAgencePoleEmploi,
    required this.organism,
    required this.address,
    required this.phone,
    required this.visioRedirectUrl,
    required this.theme,
    required this.description,
    required this.precision,
    required this.conseiller,
    required this.createur,
    required this.estInscrit,
  });

  factory JsonRendezvous.fromJson(dynamic json) {
    final conseiller = json['conseiller'] != null ? Conseiller.fromJson(json['conseiller']) : null;
    final createur = json['createur'] != null ? Conseiller.fromJson(json['createur']) : null;
    return JsonRendezvous._(
      id: json['id'] as String,
      source: _rendezvousSource(json['source'] as String?),
      date: json['date'] as String,
      isLocaleDate: json['isLocaleDate'] as bool,
      duration: json['duration'] as int,
      modality: _modality(json),
      isInVisio: json['visio'] as bool?,
      withConseiller: json['presenceConseiller'] as bool?,
      isAnnule: json['annule'] as bool?,
      type: _rendezvousType(json['type']),
      title: _title(json),
      comment: json['comment'] as String?,
      organism: json['organisme'] as String?,
      isInAgencePoleEmploi: json['agencePE'] as bool?,
      address: json['adresse'] as String?,
      phone: json['telephone'] as String?,
      visioRedirectUrl: json['lienVisio'] as String?,
      theme: json['theme'] as String?,
      description: json['description'] as String?,
      precision: json['precision'] as String?,
      conseiller: conseiller,
      createur: createur != conseiller ? createur : null,
      estInscrit: json['estInscrit'] as bool?,
    );
  }

  Rendezvous toRendezvous() {
    return Rendezvous(
      id: id,
      source: source,
      date: _dateTime(),
      duration: duration != 0 ? duration : null,
      modality: modality,
      isInVisio: isInVisio ?? false,
      withConseiller: withConseiller,
      isAnnule: isAnnule ?? false,
      type: type,
      title: title,
      comment: comment,
      organism: _organism(),
      address: address,
      phone: phone,
      visioRedirectUrl: visioRedirectUrl,
      theme: theme,
      description: description,
      precision: precision,
      conseiller: conseiller,
      createur: createur,
      estInscrit: estInscrit,
    );
  }

  String? _organism() {
    if (organism != null) return organism;
    if (isInAgencePoleEmploi == true) return _poleEmploiOrganism;
    return null;
  }

  DateTime _dateTime() {
    if (isLocaleDate) return date.toDateTimeUnconsideringTimeZone();
    return date.toDateTimeUtcOnLocalTimeZone();
  }
}

RendezvousType _rendezvousType(dynamic json) {
  return RendezvousType(parseRendezvousTypeCode(json['code'] as String), json['label'] as String);
}

RendezvousSource _rendezvousSource(String? source) {
  const defaultSource = RendezvousSource.passEmploi;
  if (source == null) return defaultSource;
  if (source == "MILO") return RendezvousSource.milo;
  return defaultSource;
}

String? _title(dynamic json) {
  final title = json['title'] as String?;
  if (title == null || title.isEmpty) return null;
  return title;
}

String? _modality(dynamic json) {
  final modality = json['modality'] as String?;
  if (modality == null || modality.isEmpty) return null;
  return modality;
}

RendezvousTypeCode parseRendezvousTypeCode(String rendezvousTypeCode) {
  return RendezvousTypeCode.values.firstWhere(
    // ignore: sdk_version_since
    (e) => e.name == rendezvousTypeCode,
    orElse: () => RendezvousTypeCode.AUTRE,
  );
}
