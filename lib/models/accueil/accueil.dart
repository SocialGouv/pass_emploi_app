import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_json_extractor.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_response.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class Accueil extends Equatable {
  final DateTime? dateDerniereMiseAJour;
  final AccueilCetteSemaine? cetteSemaine;
  final Rendezvous? prochainRendezVous;
  final SessionMilo? prochaineSessionMilo;
  final List<Rendezvous>? evenements;
  final List<Alerte>? alertes;
  final List<Favori>? favoris;
  final Campagne? campagne;

  Accueil({
    this.dateDerniereMiseAJour,
    this.cetteSemaine,
    this.prochainRendezVous,
    this.prochaineSessionMilo,
    this.evenements,
    this.alertes,
    this.favoris,
    this.campagne,
  });

  factory Accueil.fromJson(dynamic json) {
    final dateDerniereMiseAjour = _dateDerniereMiseAJour(json);
    final cetteSemaine = _cetteSemaine(json);
    final prochainRendezVous = _prochainRendezVous(json);
    final prochaineSessionMilo = _prochaineSessionMilo(json);
    final evenements = _evenements(json);
    final alertes = _alertes(json);
    final favoris = _favoris(json);
    final campagne = json["campagne"] != null ? Campagne.fromJson(json["campagne"]) : null;

    return Accueil(
      dateDerniereMiseAJour: dateDerniereMiseAjour,
      cetteSemaine: cetteSemaine,
      prochainRendezVous: prochainRendezVous,
      prochaineSessionMilo: prochaineSessionMilo,
      evenements: evenements,
      alertes: alertes,
      favoris: favoris,
      campagne: campagne,
    );
  }

  Accueil copyWith({
    final DateTime? dateDerniereMiseAJour,
    final AccueilCetteSemaine? cetteSemaine,
    final Rendezvous? prochainRendezVous,
    final SessionMilo? prochaineSessionMilo,
    final List<Rendezvous>? evenements,
    final List<Alerte>? alertes,
    final List<Favori>? favoris,
  }) {
    return Accueil(
      dateDerniereMiseAJour: dateDerniereMiseAJour ?? this.dateDerniereMiseAJour,
      cetteSemaine: cetteSemaine ?? this.cetteSemaine,
      prochainRendezVous: prochainRendezVous ?? this.prochainRendezVous,
      prochaineSessionMilo: prochaineSessionMilo ?? this.prochaineSessionMilo,
      evenements: evenements ?? this.evenements,
      alertes: alertes ?? this.alertes,
      favoris: favoris ?? this.favoris,
    );
  }

  @override
  List<Object?> get props => [
        dateDerniereMiseAJour,
        cetteSemaine,
        prochainRendezVous,
        prochaineSessionMilo,
        evenements,
        alertes,
        favoris,
      ];
}

DateTime? _dateDerniereMiseAJour(dynamic json) {
  return (json["dateDerniereMiseAJour"] as String?)?.toDateTimeUtcOnLocalTimeZone();
}

AccueilCetteSemaine? _cetteSemaine(dynamic json) {
  final cetteSemaineJson = json["cetteSemaine"];
  return cetteSemaineJson != null ? AccueilCetteSemaine.fromJson(cetteSemaineJson) : null;
}

Rendezvous? _prochainRendezVous(dynamic json) {
  final rendezvous = json["prochainRendezVous"];
  return rendezvous != null ? JsonRendezvous.fromJson(rendezvous).toRendezvous() : null;
}

SessionMilo? _prochaineSessionMilo(dynamic json) {
  final sessionMilo = json["prochaineSessionMilo"];
  return sessionMilo != null ? SessionMilo.fromJson(sessionMilo) : null;
}

List<Rendezvous>? _evenements(dynamic json) {
  final events = json["evenementsAVenir"] as List?;
  if (events == null) return null;

  return events.map((event) => JsonRendezvous.fromJson(event).toRendezvous()).toList();
}

List<Alerte>? _alertes(dynamic json) {
  final alertes = json["mesAlertes"] as List?;
  if (alertes == null) return null;

  return alertes
      .map((search) => AlerteResponse.fromJson(search))
      .map((e) => AlerteJsonExtractor().extract(e))
      .whereNotNull()
      .toList();
}

List<Favori>? _favoris(dynamic json) {
  final favoris = json["mesFavoris"] as List?;
  if (favoris == null) return null;

  return favoris.map((favori) => Favori.fromJson(favori)).whereType<Favori>().toList();
}

class AccueilCetteSemaine extends Equatable {
  final int nombreRendezVous;
  final int nombreActionsDemarchesEnRetard;
  final int nombreActionsDemarchesARealiser;

  AccueilCetteSemaine({
    required this.nombreRendezVous,
    required this.nombreActionsDemarchesEnRetard,
    required this.nombreActionsDemarchesARealiser,
  });

  factory AccueilCetteSemaine.fromJson(dynamic json) {
    return AccueilCetteSemaine(
      nombreRendezVous: json["nombreRendezVous"] as int,
      nombreActionsDemarchesEnRetard: json["nombreActionsDemarchesEnRetard"] as int,
      nombreActionsDemarchesARealiser: json["nombreActionsDemarchesARealiser"] as int,
    );
  }

  @override
  List<Object?> get props => [nombreRendezVous, nombreActionsDemarchesEnRetard, nombreActionsDemarchesARealiser];
}
