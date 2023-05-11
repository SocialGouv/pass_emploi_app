enum OffreType {
  emploi,
  alternance,
  immersion,
  serviceCivique;

  static OffreType? from(String value) {
    if (value == "OFFRES_EMPLOI") return OffreType.emploi;
    if (value == "OFFRES_ALTERNANCE") return OffreType.alternance;
    if (value == "OFFRES_IMMERSION") return OffreType.immersion;
    if (value == "OFFRES_SERVICES_CIVIQUE") return OffreType.serviceCivique;
    return null;
  }

}
