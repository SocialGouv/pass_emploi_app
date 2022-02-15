import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';

class FiltresRequest {
  static String experienceToUrlParameter(ExperienceFiltre filtre) {
    switch (filtre) {
      case ExperienceFiltre.de_zero_a_un_an:
        return "1";
      case ExperienceFiltre.de_un_a_trois_ans:
        return "2";
      case ExperienceFiltre.trois_ans_et_plus:
        return "3";
    }
  }

  static ExperienceFiltre? experienceFromUrlParameter(String url) {
    switch (url) {
      case "1":
        return ExperienceFiltre.de_zero_a_un_an;
      case "2":
        return ExperienceFiltre.de_un_a_trois_ans;
      case "3":
        return ExperienceFiltre.trois_ans_et_plus;
      default:
        return null;
    }
  }

  static String contratToUrlParameter(ContratFiltre filtre) {
    switch (filtre) {
      case ContratFiltre.cdi:
        return "CDI";
      case ContratFiltre.cdd_interim_saisonnier:
        return "CDD-interim-saisonnier";
      case ContratFiltre.autre:
        return "autre";
    }
  }

  static ContratFiltre? contratFromUrlParameter(String url) {
    switch (url) {
      case "CDI":
        return ContratFiltre.cdi;
      case "CDD-interim-saisonnier":
        return ContratFiltre.cdd_interim_saisonnier;
      case "autre":
        return ContratFiltre.autre;
      default:
        return null;
    }
  }

  static String dureeToUrlParameter(DureeFiltre filtre) {
    switch (filtre) {
      case DureeFiltre.temps_plein:
        return "1";
      case DureeFiltre.temps_partiel:
        return "2";
    }
  }

  static DureeFiltre? dureeFromUrlParameter(String url) {
    switch (url) {
      case "1":
        return DureeFiltre.temps_plein;
      case "2":
        return DureeFiltre.temps_partiel;
      default:
        return null;
    }
  }
}
