import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

enum DemarcheStatus {
  NOT_STARTED,
  IN_PROGRESS,
  DONE,
  CANCELLED;

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
  List<Object?> get props => [
        id,
        content,
        label,
        titre,
        sousTitre,
        status,
        possibleStatus,
        endDate,
        deletionDate,
        modificationDate,
        createdByAdvisor,
        modifiedByAdvisor,
        attributs,
        creationDate,
      ];
}

DemarcheStatus _statusFromString({required String statusString}) {
  if (statusString == "A_FAIRE") {
    return DemarcheStatus.NOT_STARTED;
  } else if (statusString == "EN_COURS") {
    return DemarcheStatus.IN_PROGRESS;
  } else if (statusString == "REALISEE") {
    return DemarcheStatus.DONE;
  } else if (statusString == "ANNULEE") {
    return DemarcheStatus.CANCELLED;
  } else {
    return DemarcheStatus.DONE;
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

extension DemarcheList on List<Demarche> {
  List<Demarche> withUpdatedDemarche(Demarche updatedDemarche) {
    final demarcheToUpdate = firstWhereOrNull((d) => d.id == updatedDemarche.id);
    if (demarcheToUpdate == null) return this;

    return List<Demarche>.from(this) //
        .where((d) => d.id != updatedDemarche.id)
        .toList()
      ..insert(0, updatedDemarche);
  }
}

extension DemarcheExt on Demarche {
  bool get isDemarchePersonnalisee => titre == "Action issue de l’application CEJ";

  Demarche transformDemarchePersonnalisee() {
    if (isDemarchePersonnalisee) {
      final vraiTitre = attributs.firstOrNull?.value;
      return Demarche(
        id: id,
        content: vraiTitre,
        titre: vraiTitre,
        label: label,
        status: status,
        possibleStatus: possibleStatus,
        endDate: endDate,
        deletionDate: deletionDate,
        modificationDate: modificationDate,
        createdByAdvisor: createdByAdvisor,
        modifiedByAdvisor: modifiedByAdvisor,
        sousTitre: sousTitre,
        attributs: [],
        creationDate: creationDate,
      );
    }

    return this;
  }
}
