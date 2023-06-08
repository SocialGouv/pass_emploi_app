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

  static const accueil = "accueil";
  static const accueilSuggestionsListe = "accueil/suggested_list";
  static const monSuivi = "mon_suivi";
  static const agenda = "agenda";
  static const chat = "chat";
  static const profil = "profil";

  static const userActionList = "actions/list";
  static const userActionDetails = "actions/detail";
  static const updateUserAction = "actions/detail?modifySuccess=true";
  static const createUserAction = "actions/create";
  static const searchDemarcheStep1 = "/demarches/search";
  static const searchDemarcheStep2 = "/demarches/search-results";
  static const searchDemarcheStep3 = "/demarches/demarche-renferentiel-create";
  static const searchDemarcheStep3Success = "/demarches/createSuccess";
  static const createDemarchePersonnalisee = "actions/demarche-personnalisee/create";

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

  static const rechercheV2Home = "recherche/home";
  static const rechercheSuggestionsListe = "recherche/suggested_list";

  static String rechercheInitiale(String type) => "recherche/$type/search";

  static String rechercheInitialeResultats(String type) => "recherche/$type/search_results";

  static String rechercheAfficherPlusOffres(String type) => "recherche/$type/search_results?view_more=true";

  static String rechercheModifieeResultats(String type) => "recherche/$type/search_results?update=true";


  static const emploiRecherche = "emploi";
  static const emploiDetails = "recherche/emploi/detail";
  static const emploiFiltres = "recherche/emploi/search_results/filters";
  static const emploiCreateAlert = "/saved_searches/emploi/create";
  static const emploiPartagePage = "/recherche/emploi/detail/partage-conseiller";
  static const emploiPartagePageSuccess = "/recherche/emploi/detail?partage-conseiller=true";

  static const alternanceRecherche = "alternance";
  static const alternanceDetails = "recherche/alternance/detail";
  static const alternanceFiltres = "recherche/alternance/search_results/filters";
  static const alternanceCreateAlert = "/saved_searches/alternance/create";

  static const immersionRecherche = "immersion";
  static const immersionDetails = "recherche/immersion/detail";
  static const immersionContact = "recherche/immersion/detail/contact";
  static const immersionForm = "recherche/immersion/detail/formulaire";
  static String immersionFormSent(bool succeed) => "recherche/immersion/detail/formulaire?success=$succeed";
  static const immersionFiltres = "recherche/immersion/search_results/filters";
  static const immersionCreateAlert = "/saved_searches/immersion/create";

  static const serviceCiviqueRecherche = "service_civique";
  static const serviceCiviqueDetail = "recherche/service_civique/detail";
  static const serviceCiviqueFiltres = "recherche/service_civique/search_results/filters";
  static const serviceCiviqueCreateAlert = "/saved_searches/service_civique/create";

  static const toolbox = "recherche/boite_a_outils";

  static const eventList = "events/list";
  static const eventPartagePageSuccess = "events/detail?partage-conseiller=true";

  static const evenementEmploiRecherche = "evenement_emploi";
  static const evenementEmploiDetails = "evenement_emploi/detail";
  static const evenementEmploiFiltres = "evenement_emploi/search_results/filters";

  static const offreFavorisList = "favoris/list";
  static const offreFavorisListFilterEmploi = "favoris/list?filtre=emploi";
  static const offreFavorisListFilterAlternance = "favoris/list?filtre=alternance";
  static const offreFavorisListFilterImmersion = "favoris/list?filtre=immersion";
  static const offreFavorisListFilterServiceCivique = "favoris/list?filtre=service_civique";

  static const savedSearchSuggestionsListe = "saved_searches/suggested_list";
  static const savedSearchList = "saved_searches/list";
  static const savedSearchListFilterEmploi = "saved_searches/list?filtre=emploi";
  static const savedSearchListFilterAlternance = "saved_searches/list?filtre=alternance";
  static const savedSearchListFilterImmersion = "saved_searches/list?filtre=immersion";
  static const savedSearchListFilterServiceCivique = "saved_searches/list?filtre=service_civique";

  static const savedSearchEmploiDelete = "/saved_searches/emploi/delete";
  static const savedSearchAlternanceDelete = "/saved_searches/alternance/delete";
  static const savedSearchImmersionDelete = "/saved_searches/immersion/delete";
  static const savedSearchServiceCiviqueDelete = "/saved_searches/service-civique/delete";

  static const suppressionAccount = "/profil/suppression-compte";
  static const shareActivity = "/profil/autorisation-partage-conseiller";

  static const explicationModeDemo = "/entree/mode-demo";

  static const tutorialPage = "/new-feature_tutorial";
  static const ratingPage = "/notation";

  static const actionCommentsPage = "/actions/detail/comments/view";

  static const diagorienteEntryPage = "/diagoriente";
  static const diagorienteChatBot = "/diagoriente/chatbot";
  static const diagorienteFavoris = "/diagoriente/favoris";

  static const cvListPage = "/cv/list";
}

class AnalyticsActionNames {
  AnalyticsActionNames._();

  static String emploiResultUpdateFavori(bool added) => "/solutions/emploi/search_results?favori=$added";

  static String emploiDetailUpdateFavori(bool added) => "/solutions/emploi/detail?favori=$added";

  static String alternanceResultUpdateFavori(bool added) => "/solutions/alternance/search_results?favori=$added";

  static String alternanceDetailUpdateFavori(bool added) => "/solutions/alternance/detail?favori=$added";

  static String immersionResultUpdateFavori(bool added) => "/solutions/immersion/search_results?favori=$added";

  static String immersionDetailUpdateFavori(bool added) => "/solutions/immersion/detail?favori=$added";

  static String serviceCiviqueResultUpdateFavori(bool added) =>
      "/solutions/service_civique/search_results?favori=$added";

  static String serviceCiviqueDetailUpdateFavori(bool added) => "/solutions/service_civique/detail?favori=$added";

  static String? offreFavoriUpdateFavori(bool added) => added ? null : "favoris/list?favori=$added";

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

  static const autocompleteMotCleDiagorienteMetiersFavorisEventCategory = "Préférences métiers dans les mots clés";
  static const autocompleteMotCleDiagorienteMetiersFavorisDisplayAction = "Affichage des préférences métiers";
  static const autocompleteMotCleDiagorienteMetiersFavorisClickAction = "Clic préférences métiers";

  static const autocompleteMetierDiagorienteMetiersFavorisEventCategory = "Préférences métiers dans métier";
  static const autocompleteMetierDiagorienteMetiersFavorisDisplayAction = "Affichage des préférences métiers";
  static const autocompleteMetierDiagorienteMetiersFavorisClickAction = "Clic préférences métiers";

  static const lastRechercheMotsClesEventCategory = "Dernières recherches mots clés";
  static const lastRechercheMotsClesDisplayAction = "Affichage dernières recherches mots clés";
  static const lastRechercheMotsClesClickAction = "Clic dernières recherches mots clés";

  static const lastRechercheMetierEventCategory = "Dernières recherches métiers";
  static const lastRechercheMetierDisplayAction = "Affichage dernières recherches métiers";
  static const lastRechercheMetierClickAction = "Clic dernières recherches métiers";

  static const lastRechercheLocationEventCategory = "Dernières recherches localisation";
  static const lastRechercheLocationDisplayAction = "Affichage dernières recherches localisation";
  static const lastRechercheLocationClickAction = "Clic dernières recherches localisation";
}

class AnalyticsCustomDimensions {
  static const userTypeId = '1';
  static const structureId = '2';

  static const appUserType = "jeune";
}
