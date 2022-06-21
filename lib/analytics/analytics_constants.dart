class AnalyticsScreenNames {
  AnalyticsScreenNames._();

  static const splash = "splash";
  static const forceUpdate = "force_update";
  static const entree = "entree";
  static const choixOrganisme = "entree/choix-organisme";
  static const choixOrganismePE = "entree/choix-organisme/pe";
  static const choixOrganismeMilo = "entree/choix-organisme/milo";

  static String cejInformationPage(int pageNumber) => "entree/etape-$pageNumber";

  static const evaluationDetails = "actions/tuile-evaluation";

  static const userActionList = "actions/list";
  static const userActionDetails = "actions/detail";
  static const updateUserAction = "actions/detail?modifySuccess=true";
  static const createUserAction = "actions/create";
  static const searchDemarcheStep1 = "/demarches/search";
  static const searchDemarcheStep2 = "/demarches/search-results";
  static const createDemarchePersonnalisee = "actions/demarche-personnalisee/create";

  static const chat = "chat";

  static const rendezvousListPast = "rdv/list-past";
  static const rendezvousListFuture = "rdv/list-future";
  static const rendezvousListWeek = "rdv/list-week-";
  static const rendezvousActivitesExterieures = "rdv/activites-exterieures";
  static const rendezvousAtelier = "rdv/atelier";
  static const rendezvousEntretienIndividuel = "rdv/entretien-individuel";
  static const rendezvousEntretienPartenaire = "rdv/entretien-partenaire";
  static const rendezvousInformationCollective = "rdv/information-collective";
  static const rendezvousVisite = "rdv/visite";
  static const rendezvousPrestation = "rdv/prestation";
  static const rendezvousAutre = "rdv/autre";

  static const emploiResearch = "recherche/emploi/search";
  static const emploiResults = "recherche/emploi/search_results";
  static const emploiNoResults = "recherche/emploi/search_no_results";
  static const emploiDetails = "recherche/emploi/detail";
  static const emploiFiltres = "recherche/emploi/search_results/filters";
  static const emploiCreateAlert = "/saved_search/emploi/create";

  static const alternanceResearch = "recherche/alternance/search";
  static const alternanceResults = "recherche/alternance/search_results";
  static const alternanceNoResults = "recherche/alternance/search_no_results";
  static const alternanceDetails = "recherche/alternance/detail";
  static const alternanceFiltres = "recherche/alternance/search_results/filters";
  static const alternanceCreateAlert = "/saved_search/alternance/create";

  static const immersionResearch = "recherche/immersion/search";
  static const immersionResults = "recherche/immersion/search_results";
  static const immersionNoResults = "recherche/immersion/search_no_results";
  static const immersionDetails = "recherche/immersion/detail";
  static const immersionFiltres = "/recherche/immersion/search_results/filters";
  static const immersionCreateAlert = "/saved_search/immersion/create";

  static const serviceCiviqueResearch = "recherche/service_civique/search";
  static const serviceCiviqueResults = "/recherche/service_civique/search_results";
  static const serviceCiviqueNoResults = "/recherche/service_civique/search_no_results";
  static const serviceCiviqueDetail = "/recherche/service_civique/detail";
  static const serviceCiviqueFavoris = "/favoris/list/service_civique";
  static const serviceCiviqueFiltres = "/recherche/service_civique/search_results/filters";
  static const serviceCiviqueCreateAlert = "/saved_search/service_civique/create";

  static const toolbox = "recherche/boite_a_outils";
  static const emploiFavoris = "favoris/list/emploi";
  static const alternanceFavoris = "favoris/list/alternance";
  static const immersionFavoris = "favoris/list/immersion";
  static const profil = "profil";

  static const savedSearchEmploiList = "/saved_searches/emploi/list";
  static const savedSearchAlternanceList = "/saved_searches/alternance/list";
  static const savedSearchImmersionList = "/saved_searches/immersion/list";
  static const savedSearchServiceCiviqueList = "/saved_searches/service_civique/list";

  static const savedSearchEmploiDelete = "/saved_search/emploi/delete";
  static const savedSearchAlternanceDelete = "/saved_search/alternance/delete";
  static const savedSearchImmersionDelete = "/saved_search/immersion/delete";
  static const savedSearchServiceCiviqueDelete = "/saved_search/service-civique/delete";

  static const suppressionAccount = "/profil/suppression-compte";
  static const explicationModeDemo = "/entree/mode-demo";
}

class AnalyticsActionNames {
  AnalyticsActionNames._();

  static String emploiResultUpdateFavori(bool added) => "recherche/emploi/search_results?favori=$added";

  static String emploiDetailUpdateFavori(bool added) => "recherche/emploi/detail?favori=$added";

  static String? emploiFavoriUpdateFavori(bool added) => added ? null : "favoris/list/emploi?favori=false";

  static String alternanceResultUpdateFavori(bool added) => "recherche/alternance/search_results?favori=$added";

  static String alternanceDetailUpdateFavori(bool added) => "recherche/alternance/detail?favori=$added";

  static String? alternanceFavoriUpdateFavori(bool added) => added ? null : "favoris/list/alternance?favori=false";

  static String immersionResultUpdateFavori(bool added) => "/solutions/immersion/search_results?favori=$added";

  static String immersionDetailUpdateFavori(bool added) => "/solutions/immersion/detail?favori=$added";

  static String immersionFavoriUpdateFavori(bool added) => "/favoris/list/immersion?favori=$added";

  static String serviceCiviqueResultUpdateFavori(bool added) =>
      "/solutions/service_civique/search_results?favori=$added";

  static String serviceCiviqueDetailUpdateFavori(bool added) => "/solutions/service_civique/detail?favori=$added";

  static String serviceCiviqueFavoriUpdateFavori(bool added) => "/favoris/list/service_civique?favori=$added";

  static const deleteUserAction = "actions/list?deleteSuccess=true";

  static String createSavedSearchEmploi = "/recherche/emploi/search_results?create_saved_search=true";
  static String createSavedSearchAlternance = "/recherche/alternance/search_results?create_saved_search=true";
  static String createSavedSearchImmersion = "/recherche/immersion/search_results?create_saved_search=true";
  static String createSavedSearchServiceCivique = "/recherche/service-civique/search_results?create_saved_search=true";

  static String deleteSavedSearchEmploi = "/saved_searches/emploi/list?deleteSuccess=true";
  static String deleteSavedSearchAlternance = "/saved_searches/alternance/list?deleteSuccess=true";
  static String deleteSavedSearchImmersion = "/saved_searches/immersion/list?deleteSuccess=true";
  static String deleteSavedSearchServiceCivique = "/saved_searches/service_civique/list?deleteSuccess=true";

  static const suppressionAccountConfirmation = "/profil/suppression-compte/confirm";
  static const suppressionAccountSucceded = "/login?deleteSuccess=true";
}

class AnalyticsCustomDimensions {
  static const userTypeId = 1;
  static const structureId = 2;

  static const appUserType = "jeune";
}
