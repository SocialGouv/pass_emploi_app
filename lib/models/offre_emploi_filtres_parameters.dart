import 'package:equatable/equatable.dart';

import '../ui/strings.dart';

class OffreEmploiSearchParametersFiltres extends Equatable {
  static const defaultDistanceValue = 10;

  final int? distance;
  final List<ExperienceFiltre>? experience;
  final List<ContratFiltre>? contrat;
  final List<DureeFiltre>? duree;

  OffreEmploiSearchParametersFiltres._({
    this.distance,
    this.experience,
    this.contrat,
    this.duree,
  });

  factory OffreEmploiSearchParametersFiltres.withFiltres({
    int? distance,
    List<ExperienceFiltre>? experience,
    List<ContratFiltre>? contrat,
    List<DureeFiltre>? duree,
  }) {
    return OffreEmploiSearchParametersFiltres._(
      distance: distance,
      experience: experience,
      contrat: contrat,
      duree: duree,
    );
  }

  factory OffreEmploiSearchParametersFiltres.noFiltres() {
    return OffreEmploiSearchParametersFiltres._(
      distance: null,
      experience: null,
      contrat: null,
    );
  }

  @override
  List<Object?> get props => [distance, experience, contrat, duree];
}

enum ExperienceFiltre { de_zero_a_un_an, de_un_a_trois_ans, trois_ans_et_plus }
enum ContratFiltre { cdi, cdd_interim_saisonnier, autre }
enum DureeFiltre { temps_plein, temps_partiel }

class FiltresLabels {
  static String fromExperienceToString(ExperienceFiltre filtre) {
    switch (filtre) {
      case ExperienceFiltre.de_zero_a_un_an:
        return Strings.experienceDeZeroAUnAnLabel;
      case ExperienceFiltre.de_un_a_trois_ans:
        return Strings.experienceDeUnATroisAnsLabel;
      case ExperienceFiltre.trois_ans_et_plus:
        return Strings.experienceTroisAnsEtPlusLabel;
    }
  }

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
