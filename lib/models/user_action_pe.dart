import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

enum UserActionPEStatus {
  NOT_STARTED,
  IN_PROGRESS,
  RETARDED,
  DONE,
  CANCELLED;

  int compareTo(UserActionPEStatus other) => index.compareTo(other.index);
}

class UserActionPE extends Equatable {
  final String id;
  final String? content;
  final String? label;
  final String? titre;
  final String? sousTitre;
  final UserActionPEStatus status;
  final List<UserActionPEStatus> possibleStatus;
  final DateTime? endDate;
  final DateTime? deletionDate;
  final DateTime? modificationDate;
  final DateTime? creationDate;
  final bool createdByAdvisor;
  final bool modifiedByAdvisor;
  final List<PeActionAttribut> attributs;

  UserActionPE({
    required this.id,
    required this.content,
    required this.label,
    required this.status,
    required this.possibleStatus,
    required this.endDate,
    required this.deletionDate,
    required this.modificationDate,
    required this.createdByAdvisor,
    required this.modifiedByAdvisor,
    required this.titre,
    required this.sousTitre,
    required this.attributs,
    required this.creationDate,
  });

  UserActionPE copyWithStatus(UserActionPEStatus status) {
    return UserActionPE(
      id: id,
      content: content,
      label: label,
      status: status,
      possibleStatus: possibleStatus,
      endDate: endDate,
      deletionDate: deletionDate,
      modificationDate: modificationDate,
      createdByAdvisor: createdByAdvisor,
      modifiedByAdvisor: modifiedByAdvisor,
      titre: titre,
      sousTitre: sousTitre,
      attributs: attributs,
      creationDate: creationDate,
    );
  }

  factory UserActionPE.fromJson(dynamic json) {
    return UserActionPE(
      id: json['id'] as String,
      content: json['contenu'] as String?,
      label: json['label'] as String?,
      titre: json['titre'] as String?,
      sousTitre: json['sousTitre'] as String?,
      status: _statusFromString(statusString: json['statut'] as String),
      possibleStatus: (json['statutsPossibles'] as List<dynamic>).whereType<String>().map((e) => _statusFromString(statusString: e)).toList(),
      endDate: (json['dateFin'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
      modificationDate: (json['dateModification'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
      deletionDate: (json['dateAnnulation'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
      createdByAdvisor: json['creeeParConseiller'] as bool,
      modifiedByAdvisor: json['modifieParConseiller'] as bool,
      attributs: (json["attributs"] as List<dynamic>).whereType<Map<String, dynamic>>().map((e) => PeActionAttribut(e["valeur"].toString(), e["label"] as String)).toList(),
      creationDate: (json['dateCreation'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
    );
  }

  @override
  List<Object?> get props => [id, content, status, endDate, deletionDate, createdByAdvisor];
}

UserActionPEStatus _statusFromString({required String statusString}) {
  if (statusString == "A_FAIRE") {
    return UserActionPEStatus.NOT_STARTED;
  } else if (statusString == "EN_COURS") {
    return UserActionPEStatus.IN_PROGRESS;
  } else if (statusString == "EN_RETARD") {
    return UserActionPEStatus.RETARDED;
  } else if (statusString == "REALISEE") {
    return UserActionPEStatus.DONE;
  } else if (statusString == "ANNULEE") {
    return UserActionPEStatus.CANCELLED;
  } else {
    return UserActionPEStatus.DONE;
  }
}

class PeActionAttribut extends Equatable {
  final String valeur;
  final String label;

  PeActionAttribut(this.valeur, this.label);

  @override
  List<Object?> get props => [valeur, label];
}
