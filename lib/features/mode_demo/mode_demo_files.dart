String? getDemoFileName(String url, String query) {
  if (url.contains("/home/agenda/pole-emploi")) return "home_agenda_pole_emploi";
  if (url.contains("/home/agenda")) return "home_agenda_mission_locale";
  if (url.endsWith("/home/demarches")) return "home_demarches";
  if (url.endsWith("/home/actions")) return "home_actions";
  if (url.endsWith("/favoris/offres-immersion")) return "favoris_ids_immersion";
  if (url.endsWith("/favoris/offres-emploi")) return "favoris_ids_offres_emploi";
  if (url.endsWith("/favoris/services-civique")) return "favoris_ids_service_civique";
  if (url.endsWith("/rendezvous")) return "rendez_vous_list";
  if (url.endsWith("/recherches")) return "saved_search";
  if (url.endsWith("/offres-emploi") && query.contains("alternance=true")) return "alternance_list";
  if (url.endsWith("/offres-emploi")) return "offres_emploi_list";
  if (url.endsWith("alternance_detail")) return "alternance_detail";
  if (url.endsWith("/offres-immersion")) return "offres_immersion_list";
  if (url.endsWith("/services-civique")) return "offres_services_civique";
  if (url.endsWith("/preferences")) return "preferences";
  if (url.endsWith("/referentiels/pole-emploi/types-demarches")) return "referentiel_demarches";
  if (url.endsWith("/commentaires")) return "commentaires";
  if (url.contains("recherches/suggestions")) return "suggestions_recherche";
  if (url.removeLastPath().endsWith("/services-civique")) return "service_civique_detail";
  if (url.removeLastPath().endsWith("/offres-immersion")) return "immersion_detail";
  if (url.removeLastPath().endsWith("/offres-emploi")) return "offre_emploi_detail";
  if (url.removeLastPath().endsWith("/jeunes")) return "jeune_detail";
  if (url.removeLastPath().endsWith("/rendezvous")) return "rendez_vous_detail";
  if (url.contains("/animations-collectives")) return "event_list";
  return null;
}

extension UrlExtensions on String {
  bool isSupposedToBeMocked() {
    return !contains("referentiels/communes-et-departements") &&
        !contains("fichiers") &&
        !contains("diagoriente") &&
        !contains("referentiels/metiers");
  }

  String removeLastPath() => substring(0, lastIndexOf('/'));
}
