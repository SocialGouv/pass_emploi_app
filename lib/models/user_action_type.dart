enum UserActionReferentielType {
  emploi("EMPLOI"),
  projetProfessionnel("PROJET_PROFESSIONNEL"),
  cultureSportLoisirs("CULTURE_SPORT_LOISIRS"),
  citoyennete("CITOYENNETE"),
  formation("FORMATION"),
  logement("LOGEMENT"),
  sante("SANTE");

  final String code;

  const UserActionReferentielType(this.code);

  static UserActionReferentielType fromCode(String? value) => values.firstWhere(
        (element) => element.code == value,
        orElse: () => emploi,
      );
}
