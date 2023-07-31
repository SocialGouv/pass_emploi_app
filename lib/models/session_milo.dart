import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class SessionMilo extends Equatable {
  final String id;
  final String nomSession;
  final String nomOffre;
  final DateTime dateDeDebut;
  final SessionMiloType type;
  final bool estInscrit;

  SessionMilo({
    required this.id,
    required this.nomSession,
    required this.nomOffre,
    required this.dateDeDebut,
    required this.type,
    required this.estInscrit,
  });

  factory SessionMilo.fromJson(dynamic json) {
    return SessionMilo(
      id: json["id"] as String,
      nomSession: json["nomSession"] as String,
      nomOffre: json["nomOffre"] as String,
      dateDeDebut: (json["dateHeureDebut"] as String).toDateTimeUtcOnLocalTimeZone(),
      type: SessionMiloType.fromJson(json["type"]),
      estInscrit: (json["inscription"] as String?) == "INSCRIT",
    );
  }

  @override
  List<Object?> get props => [
        id,
        nomSession,
        dateDeDebut,
        type,
        estInscrit,
      ];

  Rendezvous get toRendezVous {
    return Rendezvous(
      id: id,
      title: nomOffre + " - " + nomSession,
      date: dateDeDebut,
      type: type.toRendezvousType,
      isAnnule: false,
      source: RendezvousSource.milo,
      isInVisio: false,
      estInscrit: estInscrit,
    );
  }
}

class SessionMiloType extends Equatable {
  final SessionMiloTypeCode code;
  final String label;

  const SessionMiloType(this.code, this.label);

  @override
  List<Object?> get props => [code, label];

  factory SessionMiloType.fromJson(dynamic json) {
    return SessionMiloType(
      _parseSessionMiloTypeCode(json['code'] as String),
      json['label'] as String,
    );
  }

  RendezvousType get toRendezvousType {
    return RendezvousType(code.rendezvousTypeCode, label);
  }
}

enum SessionMiloTypeCode {
  WORKSHOP,
  COLLECTIVE_INFORMATION,
  AUTRE,
}

SessionMiloTypeCode _parseSessionMiloTypeCode(String sessionMiloTypeCode) {
  // TODO: update dart & flutter version to fix this false warning
  return SessionMiloTypeCode.values.firstWhere(
    // ignore: sdk_version_since
    (e) => e.name == sessionMiloTypeCode,
    orElse: () => SessionMiloTypeCode.AUTRE,
  );
}

extension SessionMiloTypeCodeExt on SessionMiloTypeCode {
  RendezvousTypeCode get rendezvousTypeCode {
    switch (this) {
      case SessionMiloTypeCode.WORKSHOP:
        return RendezvousTypeCode.ATELIER;
      case SessionMiloTypeCode.COLLECTIVE_INFORMATION:
        return RendezvousTypeCode.INFORMATION_COLLECTIVE;
      case SessionMiloTypeCode.AUTRE:
        return RendezvousTypeCode.AUTRE;
    }
  }
}
