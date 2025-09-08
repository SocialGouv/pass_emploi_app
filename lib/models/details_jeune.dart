import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class DetailsJeune extends Equatable {
  final DateTime? dateSignatureCgu;
  final DetailsJeuneConseiller conseiller;
  final StructureMilo? structure;
  final bool? eligibleDemarchesIA;

  DetailsJeune({
    required this.dateSignatureCgu,
    required this.conseiller,
    required this.structure,
    this.eligibleDemarchesIA,
  });

  factory DetailsJeune.fromJson(dynamic json) {
    final structure = json["structureMilo"];
    return DetailsJeune(
      dateSignatureCgu: (json["dateSignatureCGU"] as String?)?.toDateTimeUtcOnLocalTimeZone(),
      structure: structure != null ? StructureMilo.fromJson(structure) : null,
      conseiller: DetailsJeuneConseiller.fromJson(json['conseiller']),
      eligibleDemarchesIA: true, // TODO: REMETTRE ça json['eligibleDemarchesIA'] as bool?,
    );
  }

  @override
  List<Object?> get props => [dateSignatureCgu, conseiller, structure, eligibleDemarchesIA];
}

class DetailsJeuneConseiller extends Equatable {
  final String id;
  final String firstname;
  final String lastname;
  final DateTime sinceDate;

  DetailsJeuneConseiller({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.sinceDate,
  });

  factory DetailsJeuneConseiller.fromJson(dynamic json) {
    return DetailsJeuneConseiller(
      id: json['id'] as String,
      firstname: json['prenom'] as String,
      lastname: json['nom'] as String,
      sinceDate: (json['depuis'] as String).toDateTimeUtcOnLocalTimeZone(),
    );
  }

  @override
  List<Object> get props => [id, firstname, lastname, sinceDate];
}

class StructureMilo extends Equatable {
  final String id;
  final String? name;

  StructureMilo(this.id, this.name);

  factory StructureMilo.fromJson(dynamic json) {
    return StructureMilo(
      json['id'] as String,
      json['nom'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name];
}
