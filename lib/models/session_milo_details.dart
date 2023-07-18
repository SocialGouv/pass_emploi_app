import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class SessionMiloDetails extends Equatable {
  final String nomSession;
  final String nomOffre;
  final String type;
  final DateTime dateHeureDebut;
  final DateTime dateHeureFin;
  final String lieu;
  final String animateur;
  final String description;
  final String commentaire;

  SessionMiloDetails({
    required this.nomSession,
    required this.nomOffre,
    required this.type,
    required this.dateHeureDebut,
    required this.dateHeureFin,
    required this.lieu,
    required this.animateur,
    required this.description,
    required this.commentaire,
  });

  @override
  List<Object?> get props => [
        nomSession,
        nomOffre,
        type,
        dateHeureDebut,
        dateHeureFin,
        lieu,
        animateur,
        description,
        commentaire,
      ];

  factory SessionMiloDetails.fromJson(dynamic json) {
    return SessionMiloDetails(
      nomSession: json['nomSession'] as String,
      nomOffre: json['nomOffre'] as String,
      type: json['type'] as String,
      dateHeureDebut: (json['dateHeureDebut'] as String).toDateTimeUtcOnLocalTimeZone(),
      dateHeureFin: (json['dateHeureFin'] as String).toDateTimeUtcOnLocalTimeZone(),
      lieu: json['lieu'] as String,
      animateur: json['animateur'] as String? ?? "--",
      description: json['description'] as String? ?? "--",
      commentaire: json['commentaire'] as String? ?? "--",
    );
  }
}
