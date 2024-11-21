class AnalyticsScreenNames {
  AnalyticsScreenNames._();

  static const onboardingFirstLaunch = "onboarding/first-launch";
  static const onboardingAccueil = "onboarding/accueil";
  static const onboardingPushNotificationPermission = "onboarding/push-notification-permission";
  static const onboardingNavigation = "onboarding/navigation";
  static const onboardingMonSuivi = "onboarding/mon-suivi";
  static const onboardingChat = "onboarding/chat";
  static const onboardingRecherche = "onboarding/recherche";
  static const onboardingEvenements = "onboarding/evenements";
  static const onboardingoffreEnregistree = "onboarding/offreEnregistree";

  static const login = "login";
  static const forceUpdate = "force_update";

  static String cejInformationPage(int pageNumber) => "entree2/etape-$pageNumber";

  static const accueil = "accueil";
  static const monSuivi = "mon_suivi/v2";
  static const chat = "chat";
  static const cvmChat = "chat_cvm";
  static const profil = "profil";

  static const contactProfil = "profil/contact";

  static const userActionDetails = "actions/detail";
  static const userActionUpdate = "actions/update";
  static const userActionDuplicate = "actions/duplicate";
  static const updateUserAction = "actions/detail?modifySuccess=true";
  static const createUserActionStep1 = "actions/create/v2/step1";
  static const createUserActionStep2 = "actions/create/v2/step2";
  static const createUserActionStep3 = "actions/create/v2/step3";
  static const searchDemarcheStep1 = "/demarches/search";
  static const searchDemarcheStep2 = "/demarches/search-results";
  static const searchDemarcheStep3 = "/demarches/demarche-renferentiel-create";
  static const searchDemarcheStep3Success = "/demarches/createSuccess";
  static const createDemarchePersonnalisee = "demarches/creer_demarche_personalisee";
  static const thematiquesDemarche = "demarches/thematiques";

  static String thematiquesDemarcheDetails(String thematique) => "demarches/thematiques/$thematique";
  static const topDemarches = "demarches/top-demarches";

  static String topDemarcheDetails(String demarche) => "demarches/top-demarches/$demarche";

  static const rendezvousDetails = "rdv/detail";
  static const animationCollectiveDetails = "animation_collective/detail";
  static const sessionMiloDetails = "session_milo/detail";

  static const animationCollectivePartagePageSuccess = "animation_collective/detail?partage-conseiller=true";
  static const sessionMiloPartagePageSuccess = "session_milo/detail?partage-conseiller=true";

  static const rechercheHome = "recherche/home";
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
  static const benevolat = "benevolat";

  static const eventList = "events/list";

  static const evenementEmploiRecherche = "evenement_emploi";
  static const evenementEmploiDetails = "evenement_emploi/detail";
  static const evenementEmploiFiltres = "evenement_emploi/search_results/filters";
  static const evenementEmploiPartagePageSuccess = "evenement_emploi/detail?partage-conseiller=true";

  static const offreFavorisList = "favoris/list";
  static const offreFavorisListFilterEmploi = "favoris/list?filtre=emploi";
  static const offreFavorisListFilterAlternance = "favoris/list?filtre=alternance";
  static const offreFavorisListFilterImmersion = "favoris/list?filtre=immersion";
  static const offreFavorisListFilterServiceCivique = "favoris/list?filtre=service_civique";

  static const alerteSuggestionsList = "saved_searches/suggested_list";
  static const alerteList = "saved_searches/list";
  static const alerteListFromAccueil = "saved_searches/list/from-accueil";
  static const alerteListFilterEmploi = "saved_searches/list?filtre=emploi";
  static const alerteListFilterAlternance = "saved_searches/list?filtre=alternance";
  static const alerteListFilterImmersion = "saved_searches/list?filtre=immersion";
  static const alerteListFilterServiceCivique = "saved_searches/list?filtre=service_civique";

  static const alerteEmploiDelete = "/saved_searches/emploi/delete";
  static const alerteAlternanceDelete = "/saved_searches/alternance/delete";
  static const alerteImmersionDelete = "/saved_searches/immersion/delete";
  static const alerteServiceCiviqueDelete = "/saved_searches/service-civique/delete";

  static const suppressionAccount = "/profil/suppression-compte";
  static const shareActivity = "/profil/autorisation-partage-conseiller";
  static const notificationPreferences = "/profil/preferences-push-notification";

  static const explicationModeDemo = "/entree/mode-demo";

  static const tutorialPage = "/new-feature_tutorial";

  static const actionCommentsPage = "/actions/detail/comments/view";

  static const diagorienteEntryPage = "/diagoriente";
  static const diagorienteChatBot = "/diagoriente/chatbot";
  static const diagorienteFavoris = "/diagoriente/favoris";

  static const cvListPage = "/cv/list";
  static const cguPage = "cgu";
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

  static String createAlerteEmploi = "/recherche/emploi/search_results?create_saved_search=true";
  static String createAlerteAlternance = "/recherche/alternance/search_results?create_saved_search=true";
  static String createAlerteImmersion = "/recherche/immersion/search_results?create_saved_search=true";
  static String createAlerteServiceCivique = "/recherche/service-civique/search_results?create_saved_search=true";

  static String deleteAlerteEmploi = "/saved_searches/emploi/list?deleteSuccess=true";
  static String deleteAlerteAlternance = "/saved_searches/alternance/list?deleteSuccess=true";
  static String deleteAlerteImmersion = "/saved_searches/immersion/list?deleteSuccess=true";
  static String deleteAlerteServiceCivique = "/saved_searches/service_civique/list?deleteSuccess=true";

  static const suppressionAccountConfirmation = "/profil/suppression-compte/confirm";
  static const suppressionAccountSucceded = "/login?deleteSuccess=true";

  static const continueTutorial = "/new-feature_tutorial/continue";
  static const skipTutorial = "/new-feature_tutorial/skip";
  static const delayedTutorial = "/new-feature_tutorial/delayed";
  static const doneTutorial = "/new-feature_tutorial/done";

  static const skipRating = "/notation/skip";
  static const negativeRating = "/notation/defavorable";
  static const positiveRating = "/notation/favorable";

  static const contactEmailSent = "/contact/email-sent";

  static const accessToActionComments = "/actions/detail/comments/add";
}

class AnalyticsEventNames {
  AnalyticsEventNames._();

  static const loginPageLoginModeCategory = "Login - mode de connexion";
  static const loginPageLoginChoseModeAction = "Connexion en choisissant un mode";
  static const loginPageLoginDefaultModeAction = "Connexion sans choisir de mode";

  static const createActionEventCategory = "Création action/démarche";
  static const createActionDisplaySnackBarAction = "Affichage SnackBar succès";
  static const createActionClickOnSnackBarAction = "Clic détail action/démarche";
  static const createActionOfflineAction = "Action créée hors connexion";

  static const monSuiviCategory = "Mon suivi v2";
  static const monSuiviPreviousPeriodAction = "Affichage semaines précédentes";
  static const monSuiviNextPeriodAction = "Affichage semaines suivantes";
  static const monSuiviPeriodName = "Période";

  static const createActionv2EventCategory = "Création action v2";
  static const createActionResultDetailsAction = "Ouvrir le détail d'une action créée";
  static const createActionResultAnotherAction = "Créer une autre action";
  static const createActionResultDismissAction = "Fermer la page de confirmation d'une action créée";

  static const createActionStep1CategoryCategory = "Création action v2 étape 1 - Catégorie";
  static const createActionStep2TitleCategory = "Création action v2 étape 2 - Titre";
  static const createActionStep3StatusCategory = "Création action v2 étape 3 - Statut";
  static const createActionStep3RappelCategory = "Création action v2 étape 3 - Rappel";

  static String createActionStep1Action(String category) => "Catégorie : $category";

  static const createActionStep2TitleFromSuggestionAction = "Titre provenant d'une suggestion";
  static const createActionStep2TitleNotFromSuggestionAction = "Titre ne provenant pas d'une suggestion";
  static const createActionStep3EnCoursAction = "Statut : En cours";
  static const createActionStep3TermineAction = "Statut : Terminé";
  static const createActionStep3AvecRappelAction = "Rappel : Oui";
  static const createActionStep3SansRappelAction = "Rappel : Non";

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

  static const webAuthPageEventCategory = "Mire connexion mobile";
  static const webAuthPageSuccessAction = "Connexion post mire OK";
  static const webAuthPageErrorAction = "Connexion post mire KO";

  static const pushNotificationEventCategory = "Push notifications sur mobile";
  static const pushNotificationOpenedAction = "Ouverture push notification";

  static const pushNotificationAuthorizationStatusEventCategory = "Autorisation des push notifications sur mobile";
  static const pushNotificationAuthorizationStatusAction = "Autorisation";

  static const onboardingPushNotificationPermissionCategory = "Onboarding - Autorisation des push notifications";
  static const onboardingPushNotificationPermissionAcceptAction = "Activer";
  static const onboardingPushNotificationPermissionDeclineAction = "Plus tard";

  static const evenementEmploiDetailsCategory = "Détails événement emploi";
  static const evenementEmploiDetailsInscriptionAction = "Clic inscription événement emploi";

  static const cvmLoadingCategory = "CVM - temps de chargement";
  static const cvmLoadingAndroidAction = "Chargement Android";
  static const cvmLoadingIosAction = "Chargement iOS";
  static const cvmLoadingEventName = "Durée";

  static const cvmSendMessageCategory = "CVM - temps d'envoi de message";
  static const cvmSendMessageAndroidAction = "Envoi de message Android";
  static const cvmSendMessageIosAction = "Envoi de message iOS";
  static const cvmSendMessageEventName = "Durée en ms";

  static const cvmDownloadPieceJointeCategory = "CVM - temps de download d'une pièce jointe";
  static const cvmDownloadPieceJointedAction = "Temps de download d'une pièce jointe";
  static const cvmDownloadPieceJointeEventName = "Durée en ms";

  static const cvmResultCategory = "CVM - état de la page";
  static const cvmResultAndroidSuccessAction = "Chargement Android réussi";
  static const cvmResultAndroidFailureAction = "Chargement Android échoué";
  static const cvmResultIosSuccessAction = "Chargement iOS réussi";
  static const cvmResultIosFailureAction = "Chargement iOS échoué";

  static const cvmMessageCategory = "CVM - messages envoyés";
  static const cvmMessageAndroidAction = "Envoi message Android";
  static const cvmMessageIosAction = "Envoi message iOS";

  static const rendezvousVisioCategory = "Rendez-vous bénéficiaire - visio";
  static const rendezvousVisioDisplayAction = "Affichage";
  static const rendezvousVisioClickAction = "Clic";

  static const actionWithoutDescriptionCategory = "Rattrapage action sans description";

  static const createActionWithoutDescription = "Créer action sans description - popin création de l’action";
  static const createActionWithoutDescriptionAddDescription = "Ajouter description - popin création de l’action";

  static const updateActionWithoutDescription = "Terminer l’action - popin terminer l’action";
  static const updateActionWithoutDescriptionAddDescription = "Ajouter description - popin terminer l’action";

  static const a11yCategory = "Accessibilité app mobile";
  static const a11yWithScreenReader = "Avec lecteur d'écran";
  static const a11yWithoutScreenReader = "Sans lecteur d'écran";
  static const a11yWithTextScale = "Avec agrandissement de texte";
  static const a11yWithoutTextScale = "Sans agrandissement de texte";

  static String feedbackCategory(String feature) => "Feedback pour la fonctionnalité : $feature";
  static const feedback1Action = "Note 1/5";
  static const feedback2Action = "Note 2/5";
  static const feedback3Action = "Note 3/5";
  static const feedback4Action = "Note 4/5";
  static const feedback5Action = "Note 5/5";
}

class AnalyticsCustomDimensions {
  static const userTypeId = '1';
  static const structureId = '2';

  static const appUserType = "jeune";
}
