import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class SessionMiloDetails extends Equatable {
  final String id;
  final String nomSession;
  final String nomOffre;
  final SessionMiloType type;
  final DateTime dateHeureDebut;
  final DateTime dateHeureFin;
  final String lieu;
  final bool estInscrit;
  final String? animateur;
  final String? description;
  final String? commentaire;
  final bool autoinscription;
  final int? nombreDePlacesRestantes;
  final DateTime? dateMaxInscription;

  SessionMiloDetails({
    required this.id,
    required this.nomSession,
    required this.nomOffre,
    required this.type,
    required this.dateHeureDebut,
    required this.dateHeureFin,
    required this.lieu,
    required this.estInscrit,
    this.animateur,
    this.description,
    this.commentaire,
    required this.autoinscription,
    this.nombreDePlacesRestantes,
    this.dateMaxInscription,
  });

  factory SessionMiloDetails.fromJson(dynamic json) {
    return SessionMiloDetails(
      id: json['id'] as String,
      nomSession: json['nomSession'] as String,
      nomOffre: json['nomOffre'] as String,
      type: SessionMiloType.fromJson(json['type']),
      dateHeureDebut: (json['dateHeureDebut'] as String).toDateTimeUtcOnLocalTimeZone(),
      dateHeureFin: (json['dateHeureFin'] as String).toDateTimeUtcOnLocalTimeZone(),
      lieu: json['lieu'] as String,
      estInscrit: (json['inscription']?['statut'] as String?) == "INSCRIT",
      animateur: json['animateur'] as String?,
      description: json['description'] as String?,
      commentaire: json['commentaire'] as String?,
      autoinscription: json["autoinscription"] as bool,
      nombreDePlacesRestantes: json["nbPlacesDisponibles"] as int?,
      dateMaxInscription: (json["dateMaxInscription"] as String?)?.toDateTimeUtcOnLocalTimeZone(),
    );
  }

  @override
  List<Object?> get props => [
        nomSession,
        nomOffre,
        type,
        dateHeureDebut,
        dateHeureFin,
        lieu,
        estInscrit,
        animateur,
        description,
        commentaire,
        autoinscription,
        nombreDePlacesRestantes,
        dateMaxInscription,
      ];

  Rendezvous get toRendezVous {
    return Rendezvous(
      id: id,
      title: displayableTitle,
      address: lieu,
      description: description,
      date: dateHeureDebut,
      type: type.toRendezvousType,
      isAnnule: false,
      source: RendezvousSource.milo,
      isInVisio: false,
      animateur: animateur,
      comment: commentaire,
      duration: dateHeureFin.difference(dateHeureDebut).inMinutes,
      estInscrit: estInscrit,
      createdFromSessionMilo: true,
      autoinscription: autoinscription,
      nombreDePlacesRestantes: nombreDePlacesRestantes,
      dateMaxInscription: dateMaxInscription,
    );
  }

  String get displayableTitle {
    return "$nomOffre - $nomSession";
  }
}
