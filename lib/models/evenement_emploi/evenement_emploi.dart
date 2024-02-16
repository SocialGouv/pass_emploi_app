import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_modalite.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class EvenementEmploi extends Equatable {
  final String id;
  final String type;
  final String titre;
  final String ville;
  final String codePostal;
  final DateTime dateDebut;
  final DateTime dateFin;
  final List<EvenementEmploiModalite> modalites;

  EvenementEmploi({
    required this.id,
    required this.type,
    required this.titre,
    required this.ville,
    required this.codePostal,
    required this.dateDebut,
    required this.dateFin,
    required this.modalites,
  });

  @override
  List<Object?> get props => [id, type, titre, ville, codePostal, dateDebut, dateFin, modalites];
}

class JsonEvenementEmploi {
  final String id;
  final String type;
  final String titre;
  final String ville;
  final String codePostal;
  final DateTime dateDebut;
  final DateTime dateFin;
  final List<String> modalites;

  JsonEvenementEmploi({
    required this.id,
    required this.type,
    required this.titre,
    required this.ville,
    required this.codePostal,
    required this.dateDebut,
    required this.dateFin,
    required this.modalites,
  });

  factory JsonEvenementEmploi.fromJson(dynamic json) {
    return JsonEvenementEmploi(
      id: json['id'] as String,
      type: json['typeEvenement'] as String,
      titre: json['titre'] as String,
      ville: json['ville'] as String,
      codePostal: json['codePostal'] as String,
      dateDebut: (json['dateTimeDebut'] as String).toDateTimeUtcOnLocalTimeZone(),
      dateFin: (json['dateTimeFin'] as String).toDateTimeUtcOnLocalTimeZone(),
      modalites: (json['modalites'] as List<dynamic>).map((modalite) => (modalite as String)).toList(),
    );
  }

  EvenementEmploi toEvenementEmploi() {
    return EvenementEmploi(
      id: id,
      type: type,
      titre: titre,
      ville: ville,
      codePostal: codePostal,
      dateDebut: dateDebut,
      dateFin: dateFin,
      modalites: modalites.map((modalite) => EvenementEmploiModalite.from(modalite)).whereNotNull().toList(),
    );
  }
}
