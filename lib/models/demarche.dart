import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

enum DemarcheStatus {
  pasCommencee,
  enCours,
  terminee,
  annulee;

  int compareTo(DemarcheStatus other) => index.compareTo(other.index);
}

class Demarche extends Equatable {
  final String id;
  final String? content;
  final String? label;
  final String? titre;
  final String? sousTitre;
  final DemarcheStatus status;
  final List<DemarcheStatus> possibleStatus;
  final DateTime? endDate;
  final DateTime? deletionDate;
  final DateTime? modificationDate;
  final DateTime? creationDate;
  final bool createdByAdvisor;
  final bool modifiedByAdvisor;
  final List<DemarcheAttribut> attributs;

  Demarche({
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

  Demarche copyWithStatus(DemarcheStatus status) {
    return Demarche(
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

  factory Demarche.fromJson(dynamic json) {
    return Demarche(
      id: json['id'] as String,
      content: json['contenu'] as String?,
      label: json['label'] as String?,
      titre: json['titre'] as String?,
      sousTitre: json['sousTitre'] as String?,
      status: _statusFromString(statusString: json['statut'] as String),
      possibleStatus: (json['statutsPossibles'] as List<dynamic>)
          .whereType<String>()
          .map((e) => _statusFromString(statusString: e))
          .toList(),
      endDate: (json['dateFin'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
      modificationDate: (json['dateModification'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
      deletionDate: (json['dateAnnulation'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
      createdByAdvisor: json['creeeParConseiller'] as bool,
      modifiedByAdvisor: json['modifieParConseiller'] as bool,
      attributs: (json["attributs"] as List).map((attribut) => DemarcheAttribut.fromJson(attribut)).toList(),
      creationDate: (json['dateCreation'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
    );
  }

  @override
  List<Object?> get props => [id, content, status, endDate, deletionDate, createdByAdvisor];
}

DemarcheStatus _statusFromString({required String statusString}) {
  if (statusString == "A_FAIRE") {
    return DemarcheStatus.pasCommencee;
  } else if (statusString == "EN_COURS") {
    return DemarcheStatus.enCours;
  } else if (statusString == "REALISEE") {
    return DemarcheStatus.terminee;
  } else if (statusString == "ANNULEE") {
    return DemarcheStatus.annulee;
  } else {
    return DemarcheStatus.terminee;
  }
}

class DemarcheAttribut extends Equatable {
  final String key;
  final String value;

  DemarcheAttribut({required this.key, required this.value});

  factory DemarcheAttribut.fromJson(dynamic json) {
    return DemarcheAttribut(
      key: json['cle'] as String,
      value: json['valeur'].toString(),
    );
  }

  @override
  List<Object?> get props => [key, value];
}
