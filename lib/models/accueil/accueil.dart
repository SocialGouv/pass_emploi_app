import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_json_extractor.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_response.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class Accueil extends Equatable {
  final DateTime? dateDerniereMiseAJour;
  final AccueilCetteSemaine? cetteSemaine;
  final Rendezvous? prochainRendezVous;
  final List<Rendezvous>? evenements;
  final List<SavedSearch>? alertes;
  final List<Favori>? favoris;

  Accueil({
    this.dateDerniereMiseAJour,
    this.cetteSemaine,
    this.prochainRendezVous,
    this.evenements,
    this.alertes,
    this.favoris,
  });

  factory Accueil.fromJson(dynamic json) {
    final dateDerniereMiseAjour = _dateDerniereMiseAJour(json);
    final cetteSemaine = _cetteSemaine(json);
    final prochainRendezVous = _prochainRendezVous(json);
    final evenements = _evenements(json);
    final alertes = _alertes(json);
    final favoris = _favoris(json);
    return Accueil(
      dateDerniereMiseAJour: dateDerniereMiseAjour,
      cetteSemaine: cetteSemaine,
      prochainRendezVous: prochainRendezVous,
      evenements: evenements,
      alertes: alertes,
      favoris: favoris,
    );
  }

  Accueil copyWith({
    final DateTime? dateDerniereMiseAjour,
    final AccueilCetteSemaine? cetteSemaine,
    final Rendezvous? prochainRendezVous,
    final List<Rendezvous>? evenements,
    final List<SavedSearch>? alertes,
    final List<Favori>? favoris,
  }) {
    return Accueil(
      dateDerniereMiseAJour: dateDerniereMiseAjour ?? dateDerniereMiseAJour,
      cetteSemaine: cetteSemaine ?? cetteSemaine,
      prochainRendezVous: prochainRendezVous ?? prochainRendezVous,
      evenements: evenements ?? evenements,
      alertes: alertes ?? alertes,
      favoris: favoris ?? favoris,
    );
  }

  @override
  List<Object?> get props => [dateDerniereMiseAJour, cetteSemaine, prochainRendezVous, evenements, alertes, favoris];
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

List<Rendezvous>? _evenements(dynamic json) {
  final events = json["evenementsAVenir"] as List?;
  if (events == null) return null;

  return events.map((event) => JsonRendezvous.fromJson(event).toRendezvous()).toList();
}

List<SavedSearch>? _alertes(dynamic json) {
  final alertes = json["mesAlertes"] as List?;
  if (alertes == null) return null;

  return alertes
      .map((search) => SavedSearchResponse.fromJson(search))
      .map((e) => SavedSearchJsonExtractor().extract(e))
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
