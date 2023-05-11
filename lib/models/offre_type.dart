enum OffreType {
  emploi,
  alternance,
  immersion,
  serviceCivique;

  static OffreType? from(String value) {
    if (["OFFRE_EMPLOI", "OFFRES_EMPLOI"].contains(value)) return OffreType.emploi;
    if (["OFFRE_ALTERNANCE", "OFFRES_ALTERNANCE"].contains(value)) return OffreType.alternance;
    if (["OFFRE_IMMERSION", "OFFRES_IMMERSION"].contains(value)) return OffreType.immersion;
    if (["OFFRE_SERVICE_CIVIQUE", "OFFRES_SERVICES_CIVIQUE"].contains(value)) return OffreType.serviceCivique;
    return null;
  }
}
