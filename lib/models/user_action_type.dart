enum UserActionReferentielType {
  emploi,
  projetProfessionnel,
  cultureSportLoisirs,
  citoyennete,
  formation,
  logement,
  sante;
}

extension UserActionReferentielTypeExt on UserActionReferentielType {
  String get toCode => switch (this) {
        UserActionReferentielType.emploi => "EMPLOI",
        UserActionReferentielType.projetProfessionnel => "PROJET_PROFESSIONNEL",
        UserActionReferentielType.cultureSportLoisirs => "CULTURE_SPORT_LOISIRS",
        UserActionReferentielType.citoyennete => "CITOYENNETE",
        UserActionReferentielType.formation => "FORMATION",
        UserActionReferentielType.logement => "LOGEMENT",
        UserActionReferentielType.sante => "SANTE",
      };

  static UserActionReferentielType? fromCode(String? value) => switch (value) {
        "EMPLOI" => UserActionReferentielType.emploi,
        "PROJET_PROFESSIONNEL" => UserActionReferentielType.projetProfessionnel,
        "CULTURE_SPORT_LOISIRS" => UserActionReferentielType.cultureSportLoisirs,
        "CITOYENNETE" => UserActionReferentielType.citoyennete,
        "FORMATION" => UserActionReferentielType.formation,
        "LOGEMENT" => UserActionReferentielType.logement,
        "SANTE" => UserActionReferentielType.sante,
        _ => null,
      };
}
