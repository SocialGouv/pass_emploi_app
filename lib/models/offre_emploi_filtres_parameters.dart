class OffreEmploiSearchParametersFiltres {
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
}

enum ExperienceFiltre { de_zero_a_un_an, de_un_a_trois_ans, trois_ans_et_plus }
enum ContratFiltre { cdi, cdd_interim_saisonnier, autre }
enum DureeFiltre { temps_plein, temps_partiel }
