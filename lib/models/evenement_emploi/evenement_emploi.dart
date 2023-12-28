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
  final DateTime date;
  final String heureDebut;
  final String heureFin;
  final List<String> modalites;

  JsonEvenementEmploi({
    required this.id,
    required this.type,
    required this.titre,
    required this.ville,
    required this.codePostal,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
    required this.modalites,
  });

  factory JsonEvenementEmploi.fromJson(dynamic json) {
    return JsonEvenementEmploi(
      id: json['id'] as String,
      type: json['typeEvenement'] as String,
      titre: json['titre'] as String,
      ville: json['ville'] as String,
      codePostal: json['codePostal'] as String,
      date: (json['dateEvenement'] as String).toDateTimeUnconsideringTimeZone(),
      heureDebut: json['heureDebut'] as String,
      heureFin: json['heureFin'] as String,
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
      dateDebut: date,
      dateFin: _getDateFin(date, heureDebut, heureFin),
      modalites: modalites.map((modalite) => EvenementEmploiModalite.from(modalite)).whereNotNull().toList(),
    );
  }

  /// Heure format: 'HH:mm:ss'
  DateTime _getDateFin(DateTime date, String heureDebut, String heureFin) {
    return date.add(_heureToDuration(heureFin) - _heureToDuration(heureDebut));
  }

  /// Heure format: 'HH:mm:ss'
  Duration _heureToDuration(String heure) {
    final heureSplit = heure.split(':');
    return Duration(hours: int.parse(heureSplit[0]), minutes: int.parse(heureSplit[1]));
  }
}
