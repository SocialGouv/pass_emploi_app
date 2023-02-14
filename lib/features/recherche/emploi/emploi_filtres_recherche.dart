import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class EmploiFiltresRecherche extends Equatable {
  static const defaultDistanceValue = 10;

  final int? distance;
  final bool? debutantOnly;
  final List<ExperienceFiltre>? experience;
  final List<ContratFiltre>? contrat;
  final List<DureeFiltre>? duree;

  EmploiFiltresRecherche._({
    this.distance,
    this.debutantOnly,
    this.experience,
    this.contrat,
    this.duree,
  });

  factory EmploiFiltresRecherche.withFiltres({
    int? distance,
    bool? debutantOnly,
    List<ExperienceFiltre>? experience,
    List<ContratFiltre>? contrat,
    List<DureeFiltre>? duree,
  }) {
    return EmploiFiltresRecherche._(
      distance: distance,
      debutantOnly: debutantOnly,
      experience: experience,
      contrat: contrat,
      duree: duree,
    );
  }

  factory EmploiFiltresRecherche.noFiltre() {
    return EmploiFiltresRecherche._(
      distance: null,
      debutantOnly: null,
      experience: null,
      contrat: null,
    );
  }

  @override
  List<Object?> get props => [distance, debutantOnly, experience, contrat, duree];
}

enum ExperienceFiltre { de_zero_a_un_an, de_un_a_trois_ans, trois_ans_et_plus }

enum ContratFiltre { cdi, cdd_interim_saisonnier, autre }

enum DureeFiltre { temps_plein, temps_partiel }

class FiltresLabels {
  static String fromContratToString(ContratFiltre filtre) {
    switch (filtre) {
      case ContratFiltre.cdi:
        return Strings.contratCdiLabel;
      case ContratFiltre.cdd_interim_saisonnier:
        return Strings.contratCddInterimSaisonnierLabel;
      case ContratFiltre.autre:
        return Strings.contratAutreLabel;
    }
  }

  static String fromDureeToString(DureeFiltre filtre) {
    switch (filtre) {
      case DureeFiltre.temps_plein:
        return Strings.dureeTempsPleinLabel;
      case DureeFiltre.temps_partiel:
        return Strings.dureeTempsPartielLabel;
    }
  }
}
