import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
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
  if (cetteSemaineJson == null) return null;
  return AccueilCetteSemaine.fromJson(cetteSemaineJson);
}

Rendezvous? _prochainRendezVous(dynamic json) {
  return null;
}

List<Rendezvous>? _evenements(dynamic json) {
  return null;
}

List<SavedSearch>? _alertes(dynamic json) {
  return null;
}

List<Favori>? _favoris(dynamic json) {
  return null;
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
