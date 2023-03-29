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
  return null;
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
  @override
  List<Object?> get props => [];
}
