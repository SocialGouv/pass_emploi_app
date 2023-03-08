class AnalyticsScreenNames {
  AnalyticsScreenNames._();

  static const splash = "splash";
  static const login = "login";
  static const forceUpdate = "force_update";
  static const entree = "entree";
  static const choixOrganisme = "entree/choix-organisme";
  static const choixOrganismePE = "entree/choix-organisme/pe";
  static const choixOrganismeMilo = "entree/choix-organisme/milo";

  static String cejInformationPage(int pageNumber) => "entree/etape-$pageNumber";

  static const evaluationDetails = "actions/tuile-evaluation";

  static const agenda = "agenda";

  static const userActionList = "actions/list";
  static const userActionDetails = "actions/detail";
  static const updateUserAction = "actions/detail?modifySuccess=true";
  static const createUserAction = "actions/create";
  static const searchDemarcheStep1 = "/demarches/search";
  static const searchDemarcheStep2 = "/demarches/search-results";
  static const searchDemarcheStep3 = "/demarches/demarche-renferentiel-create";
  static const searchDemarcheStep3Success = "/demarches/createSuccess";
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

  // Recherche V2
  static const rechercheV2Home = "recherche/home";
  static const rechercheSuggestionsListe = "recherche/suggested_list";
  static String rechercheInitiale(String type) => "recherche/$type/search";
  static String rechercheInitialeResultats(String type) => "recherche/$type/search_results";
  static String rechercheAfficherPlusOffres(String type) => "recherche/$type/search_results?view_more=true";
  static String rechercheModifieeResultats(String type) => "recherche/$type/search_results?update=true";

  static const emploiDetails = "recherche/emploi/detail";
  static const emploiFiltres = "recherche/emploi/search_results/filters";
  static const emploiCreateAlert = "/saved_search/emploi/create";
  static const emploiPartagePage = "/recherche/emploi/detail/partage-conseiller";
  static const emploiPartagePageSuccess = "/recherche/emploi/detail?partage-conseiller=true";

  static const alternanceResults = "recherche/alternance/search_results";
  static const alternanceDetails = "recherche/alternance/detail";
  static const alternanceFiltres = "recherche/alternance/search_results/filters";
  static const alternanceCreateAlert = "/saved_search/alternance/create";

  static const immersionDetails = "recherche/immersion/detail";
  static const immersionContact = "recherche/immersion/detail/contact";
  static const immersionFiltres = "/recherche/immersion/search_results/filters";
  static const immersionCreateAlert = "/saved_search/immersion/create";

  static const serviceCiviqueResults = "/recherche/service_civique/search_results";
  static const serviceCiviqueDetail = "/recherche/service_civique/detail";
  static const serviceCiviqueFavoris = "/favoris/list/service_civique";
  static const serviceCiviqueFiltres = "/recherche/service_civique/search_results/filters";
  static const serviceCiviqueCreateAlert = "/saved_search/service_civique/create";

  static const eventList = "events/list";
  static const toolbox = "recherche/boite_a_outils";
  static const emploiFavoris = "favoris/list/emploi";
  static const alternanceFavoris = "favoris/list/alternance";
  static const immersionFavoris = "favoris/list/immersion";
  static const profil = "profil";

  static const eventPartagePageSuccess = "events/detail?partage-conseiller=true";

  static const savedSearchEmploiList = "/saved_searches/emploi/list";
  static const savedSearchAlternanceList = "/saved_searches/alternance/list";
  static const savedSearchImmersionList = "/saved_searches/immersion/list";
  static const savedSearchServiceCiviqueList = "/saved_searches/service_civique/list";

  static const savedSearchEmploiDelete = "/saved_search/emploi/delete";
  static const savedSearchAlternanceDelete = "/saved_search/alternance/delete";
  static const savedSearchImmersionDelete = "/saved_search/immersion/delete";
  static const savedSearchServiceCiviqueDelete = "/saved_search/service-civique/delete";

  static const suppressionAccount = "/profil/suppression-compte";
  static const shareActivity = "/profil/autorisation-partage-conseiller";

  static const explicationModeDemo = "/entree/mode-demo";

  static const tutorialPage = "/new-feature_tutorial";
  static const ratingPage = "/notation";

  static const actionCommentsPage = "/actions/detail/comments/view";
}

class AnalyticsActionNames {
  AnalyticsActionNames._();

  static String emploiResultUpdateFavori(bool added) => "recherche/emploi/search_results?favori=$added";

  static String emploiDetailUpdateFavori(bool added) => "recherche/emploi/detail?favori=$added";

  static String? emploiFavoriUpdateFavori(bool added) => added ? null : "favoris/list/emploi?favori=false";

  static String alternanceResultUpdateFavori(bool added) => "/solutions/alternance/search_results?favori=$added";

  static String alternanceDetailUpdateFavori(bool added) => "/solutions/alternance/detail?favori=$added";

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

  static const continueTutorial = "/new-feature_tutorial/continue";
  static const skipTutorial = "/new-feature_tutorial/skip";
  static const delayedTutorial = "/new-feature_tutorial/delayed";
  static const doneTutorial = "/new-feature_tutorial/done";

  static const skipRating = "/notation/skip";
  static const negativeRating = "/notation/defavorable";
  static const positiveRating = "/notation/favorable";

  static const accessToActionComments = "/actions/detail/comments/add";
  static const sendComment = "/actions/detail/comments/send";
}

class AnalyticsEventNames {
  AnalyticsEventNames._();

  static const createActionEventCategory = "Création action/démarche";
  static const createActionDisplaySnackBarAction = "Affichage SnackBar succès";
  static const createActionClickOnSnackBarAction = "Clic détail action/démarche";
}

class AnalyticsCustomDimensions {
  static const userTypeId = '1';
  static const structureId = '2';

  static const appUserType = "jeune";
}
