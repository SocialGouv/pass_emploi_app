class Strings {
  Strings._();

  // Common
  static String appName = "CEJ";
  static String retry = "Réessayer";
  static String logoTextDescription = "Logo CEJ";
  static String close = "Fermer";

  // Menu
  static String menuMonSuivi = "Mon suivi";
  static String menuChat = "Messages";
  static String menuSolutions = "Recherche";
  static String menuFavoris = "Favoris";
  static String menuRendezvous = "Rendez-vous";
  static String menuProfil = "Profil";

  // Chat
  static String yourMessage = "Votre message…";
  static String yourConseiller = "Votre conseiller";
  static String today = "Aujourd'hui";
  static String read = "Lu";
  static String sent = "Envoyé";
  static String chatError = "Erreur lors de la récupération de votre messagerie";

  static String chatWith(firstName) => "Discuter avec $firstName";

  static String simpleDayFormat(day) => "Le $day";

  // Force Update
  static String updateTitle = "Mise à jour";
  static String updateButton = "Mettre à jour";
  static String forceUpdateOnStoreLabel = "Votre application nécessite d\'être mise à jour pour son bon fonctionnement";
  static String forceUpdateOnFirebaseLabel =
      "Votre application nécessite d\'être mise à jour sur Firebase pour son bon fonctionnement";

  static String hello(firstName) => "Bonjour $firstName";

  // Loader (Splash)
  static String welcomeOn = "Bienvenue sur";

  // Entree
  static String askAccount = "Demander un compte";
  static String suiviParConseiller = "Je suis suivi par un conseiller...";
  static String dontHaveAccount = "Vous n’avez pas de compte sur cette application ?";

  // Choix organisme
  static String interestedInCej = "Vous êtes intéressé et vous pensez être éligible au Contrat Engagement Jeune ?";
  static String whichOrganisme = "De quel organisme dépend votre conseiller principal ?";
  static String noOrganisme = "Je ne suis inscrit à aucun de ces organismes";
  static String rendezVousPoleEmploi =
      "Prenez rendez-vous avec votre conseiller Pôle emploi qui procédera à la création de votre compte.";
  static String rendezVousMissionLocale =
      "Prenez rendez-vous avec votre conseiller Mission Locale qui procédera à la création de votre compte.";
  static String alreadyHaveAccount = "Vous avez déjà un compte sur cette application ?";

  // Onboarding
  static String skip = "Passer";
  static String continueLabel = "Continuer";

  static String whyThisApp = "Pourquoi cette application ?";
  static String whyThisAppDesc = "C’est l’application dédiée aux bénéficiaires du Contrat Engagement Jeune (CEJ)";
  static String customService = "Un suivi personnalisé";
  static String customServiceDesc = "Suivez toutes vos actions en lien avec vos démarches professionnelles.";
  static String favoredContact = "Un moyen de contact privilégié";
  static String favoredContactDesc = "Restez en contact avec votre conseiller à l’aide d’une messagerie instantanée.";
  static String searchTool = "Un outil de recherche";
  static String searchToolDesc = "Recherchez un emploi, gérez vos offres favorites et trouvez des solutions.";
  static String whatIsCej = "Qu’est-ce que le Contrat Engagement Jeune ?";
  static String customServiceCejDesc =
      "Pendant plusieurs mois, vous êtes accompagnés de 15 à 20 heures par semaine minimum.";
  static String uniqueReferent = "Un référent unique";
  static String uniqueReferentDesc = "Un conseiller vous accompagne tout au long de votre parcours.";
  static String financialHelp = "Une allocation financière";
  static String financialHelpDesc = "Une allocation pouvant aller jusqu’à 500 euros par mois si vous en avez besoin.";
  static String whoIsConcerned = "Qui est concerné ?";
  static List<String> whoIsConcernedFirstRichText = [
    "→ Les personnes entre ",
    "16 et 25 ans",
    " (moins de ",
    "30 ans",
    " pour celles en situation de handicap)",
  ];
  static List<String> whoIsConcernedSecondRichText = [
    "→ Les personnes qui ne sont ",
    "pas en formation ni en emploi durable",
    " (CDI ou CDD de longue durée)",
  ];

  // Login
  static String performLogin = "Connectez-vous";
  static String mandatoryAccessCodeError = "Votre code d\'accès doit être renseigné";
  static String yourAccessCode = "Votre code d\'accès";
  static String loginError = "Erreur lors de la connexion";
  static String loginPassEmploi = "pass emploi";
  static String loginPoleEmploi = "Pôle emploi";
  static String loginMissionLocale = "Mission Locale";
  static String loginAction = "Se connecter";
  static String logoutAction = "Se déconnecter";

  // Mon Suivi
  static String monSuiviAppBarTitle = "Mon suivi";
  static String actionsTabTitle = "Actions";
  static String rendezvousTabTitle = "Rendez-vous";

  // Rendez-Vous
  static String myRendezVous = "Mon rendez-vous";
  static String rendezVousConseillerCommentLabel = "Commentaire de mon conseiller";
  static String cantMakeItNoBigDeal = "Vous n’êtes pas disponible sur ce créneau ?";
  static String shouldInformConseiller =
      "Il est impératif de prévenir votre conseiller et de justifier votre absence. Pour cela, contactez-le grâce à la messagerie.";

  static String rendezVousModalityMessage(modality) => "Le rendez-vous se fera $modality";
  static String noUpcomingRendezVous =
      "Vous n’avez pas de rendez-vous prévus.\nContactez votre conseiller pour prendre rendez-vous";
  static String rendezVousError = "Erreur lors de la récupération de vos rendez-vous";

  // User Action
  static String actionsError = "Erreur lors de la récupération de vos actions";
  static String actionDone = "Terminée";
  static String aboutThisAction = "À propos de cette action";
  static String actionDetails = "Détail de l'action";
  static String updateStatus = "Changer le statut";
  static String refreshActionStatus = "Actualiser";
  static String actionToDo = "À réaliser";
  static String actionInProgress = "Commencée";
  static String noActionsYet = "Vous n'avez pas encore d’actions";
  static String addAnAction = "Créer une action";
  static String create = "Créer";
  static String actionLabel = "Intitulé de l'action";
  static String actionDescription = "Description de l'action";
  static String mandatoryActionLabelError = "L'intitulé de l'action doit être renseigné";
  static String defineActionStatus = "Définir le statut";
  static String actionCreatedBy = "Créée par";
  static String actionCreationError = "Erreur lors de la création de l'action. Veuillez réessayer";
  static String you = "Vous";
  static String congratulationsActionUpdated =
      "Félicitations !\n\nLa mise à jour de votre action a bien été prise en compte";
  static String conseillerNotifiedActionUpdated =
      "Votre conseiller a reçu une notification de la mise à jour de votre action";
  static String understood = "Bien compris";
  static String deleteAction = "Supprimer l'action";
  static String deleteActionError = "Erreur lors de la suppression de l'action. Veuillez réessayer";
  static String deleteActionSuccess = "L’action a bien été supprimée";
  static String linkDetailsRendezVous = "Voir les détails du rendez-vous";

  static String lastUpdateFormat(String formattedDate) => "Modifiée le $formattedDate";
  static String doneActionsTitle = "Actions terminées";

  // Solutions
  static String searchingPageTitle = "Recherche de solutions";
  static String keyWordsTitle = "Mots clés";
  static String keyWordsTextHint = "Saisissez un métier, une compétence...";
  static String jobLocationTitle = "Lieu de travail";
  static String jobLocationHint = "Saisissez une ville, un département ou une région";
  static String searchButton = "Rechercher";
  static String offresEmploiTitle = "Offres d'emploi";
  static String offreDetails = "Détails de l'offre";
  static String offresTabTitle = "Offres";
  static String boiteAOutilsTabTitle = "Boîte à outils";
  static String solutionsAppBarTitle = "Recherche";
  static String immersionButton = "Immersion";
  static String offresEmploiButton = "Emploi";
  static String serviceCiviqueButton = "Service civique";

  // Alternance
  static String alternanceButton = "Alternance";
  static String alternanceTitle = "Offres d'alternance";

  // Immersion
  static String immersionLabel = "Découvrez un métier en immersion dans une entreprise.";
  static String metierCompulsoryLabel = "* Métier";
  static String villeCompulsoryLabel = "* Localisation";
  static String immersionExpansionTileTitle = "En savoir plus sur l’immersion";
  static String immersionObjectifTitle = "Objectif poursuivi ?";
  static String immersionObjectifContent =
      "Passer quelques jours dans une entreprise pour découvrir un métier, en conditions réelles. Ainsi, vous pouvez vérifier que ce métier vous plaît et que vous vous sentirez à l'aise pour le pratiquer. Le professionnel qui vous guidera pendant cette immersion pourra vous dire si vous avez besoin d'une formation avant de pouvoir être recruté.";
  static String immersionDemarchesTitle = "Quelles démarches ?";
  static String immersionDemarchesContent =
      "Une fois que vous avez trouvé une entreprise pour vous accueillir, prévenez votre conseiller et complétez la convention qu'il vous transmettra. Cette convention devra être validée par vous, par l'entreprise d'accueil et par votre conseiller.";
  static String immersionStatutTitle = "Quel statut ?";
  static String immersionStatutContent =
      "Votre statut ne change pas. Si vous êtes inscrit à Pôle emploi, actualisez-vous comme d'habitude !";
  static String immersionFieldHint = "Rechercher";
  static String immersionsTitle = "Offres d'immersion";
  static String immersionError = "Erreur lors de la récupération de l'offre d'immersion. Veuillez réessayer";
  static String immersionNonVolontaireExplanation =
      "Cette entreprise peut recruter sur ce métier et être intéressée pour vous recevoir en immersion. Contactez-la en expliquant votre projet professionnel et vos motivations.";
  static String immersionVolontaireExplanation = "Cette entreprise recherche activement des candidats à l’immersion.";
  static String immersionUnknownContactModeExplanation =
      "Contactez-la en expliquant votre projet professionnel et vos motivations.";
  static String immersionPhoneContactModeExplanation =
      "Contactez-la par téléphone en expliquant votre projet professionnel et vos motivations.";
  static String immersionMailContactModeExplanation =
      "Contactez-la par e-mail en expliquant votre projet professionnel et vos motivations.\n\nVous n’avez pas besoin d’envoyer un CV.";
  static String immersionInPersonContactModeExplanation =
      "Rendez-vous directement sur place pour expliquer votre projet professionnel et vos motivations.";
  static String immersionDescriptionLabel = "Si l’entreprise est d’accord pour vous accueillir :\n\n"
      "· Prévenez votre conseiller\n"
      "· Remplissez une convention d’immersion avec lui";
  static String immersionContactTitle = "Contact";
  static String immersionPhoneButton = "Appeler";
  static String immersionLocationButton = "Localiser l\'entreprise";
  static String immersionEmailButton = "Envoyer un e-mail";
  static String immersionEmailSubject = "Candidature pour une période d'immersion";

  // Civic Service
  static String serviceCiviqueTitle = "Qu’est-ce que le service civique ?";
  static String serviceCiviqueContent =
      "Le service civique est un engagement volontaire au service de l'intérêt général, accessible sans condition de diplôme. Il est indemnisé et s'effectue en France ou à l'étranger.";
  static String serviceCiviqueButtonAction = "Rechercher un service civique";
  static String serviceCiviqueUrl = "https://www.service-civique.gouv.fr/missions/";

  // Immersion Errors
  static String immersionMetierError = "Renseignez un secteur d'activité de la liste";
  static String immersionVilleError = "Renseignez une ville de la liste";

  // Solutions Errors
  static String noContentError =
      "Pour le moment, aucune offre ne correspond à vos critères.\n\nTrouvez d'autres offres en modifiant vos critères.";
  static String genericError = "Erreur lors de la recherche. Veuillez réessayer";
  static String loadMoreOffresError = "Erreur lors du chargement des offres";
  static String updateCriteria = "Modifier les critères de recherche";

  // Offre emploi filtres
  static String filtrer = "Filtrer";
  static String offresEmploiFiltresTitle = "Filtrer les annonces";
  static String searchRadius = "Dans un rayon de : ";
  static String applyFiltres = "Appliquer les filtres";

  static String kmFormat(int int) => "$int km";
  static String experienceSectionTitle = "Expérience";
  static String experienceDeZeroAUnAnLabel = "De 0 à 1 an";
  static String experienceDeUnATroisAnsLabel = "De 1 an à 3 ans";
  static String experienceTroisAnsEtPlusLabel = "3 ans et +";
  static String contratSectionTitle = "Type de contrat";
  static String contratCdiLabel = "CDI";
  static String contratCdiTooltip = "CDI et CDI Intérimaire";
  static String contratCddInterimSaisonnierLabel = "CDD - intérim - saisonnier";
  static String contratAutreLabel = "Autres";
  static String contratAutreTooltip =
      "Profession commerciale, Franchise, Profession libérale, Reprise d’entreprise, Contrat travail temporaire insertion";
  static String dureeSectionTitle = "Temps de travail";
  static String dureeTempsPleinLabel = "Temps plein";
  static String dureeTempsPartielLabel = "Temps partiel";

  // Offre emploi details
  static String offreDetailsError = "Erreur lors de la récupération de l'offre";
  static String offreDetailsTitle = "Détail de l'offre";
  static String profileTitle = "Profil souhaité";
  static String experienceTitle = "Expérience";
  static String companyDescriptionTitle = "Détail de l'entreprise";
  static String companyAdaptedTitle = "Entreprise adaptée";
  static String companyAccessibilityTitle = "Entreprise handi-bienveillante";
  static String companyTitle = "Entreprise";
  static String skillsTitle = "Savoirs et savoir-faire";
  static String softSkillsTitle = "Savoir-être professionnels";
  static String languageTitle = "Langue";
  static String educationTitle = "Formation";
  static String driverLicenceTitle = "Permis";
  static String subscribeButtonTitle = "Recevoir l'offre par mail";
  static String postulerButtonTitle = "Je postule";
  static String requiredIcon = "Obligatoire";
  static String offreNotFoundError = "Cette offre n’existe plus ou est momentanément suspendue";
  static String offreNotFoundExplaination =
      "Vous pouvez décider de la supprimer ou bien de la conserver dans vos favoris.";
  static String deleteOffreFromFavori = "Supprimer des favoris";

  // Favoris
  static String miscellaneousErrorRetry = "Une erreur est survenue. Veuillez réessayer";

  static String offreDetailNumber(String offreId) => "Offre n°$offreId";

  static String offreDetailLastUpdate(String lastUpdate) => "Actualisée le $lastUpdate";
  static String noFavoris = "Aucun favori";
  static String favorisError = "Erreur lors de la récupération de vos favoris";

  // Unavailable content (actions & rdv) for pole emploi users
  static String rendezvous = "rendez-vous";
  static String actions = "actions";

  static String unavailableContentTitle(String content) => "Vos $content ne sont pas accessibles sur l’application.";
  static String unvailableContentDescription = "Vous pouvez les consulter sur votre espace personnel Pôle emploi.";
  static String poleEmploiUrlButton = "Accéder à mon espace Pôle emploi";
  static String espacePoleEmploiUrl = "https://candidat.pole-emploi.fr/espacepersonnel/";

  // Profil
  static String personalInformation = "Informations personnelles";
  static String emailAddressLabel = "Adresse e-mail";
  static String missingEmailAddressValue = "Non renseignée";
  static String legalInformation = "Informations légales";
  static String legalNoticeLabel = "Mentions légales";
  static String privacyPolicyLabel = "Politique de confidentialité";
  static String accessibilityLevelLabel = "Niveau d’accessibilité";
  static String accessibilityLevelNonConforme = "Non conforme";
  static String termsOfServiceLabel = "Conditions d'Utilisation";

  static const legalNoticeUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_mentions_legales";
  static const privacyPolicyUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_politique_de_confidentialite";
  static const termsOfServiceUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_conditions_generales";
  static const accessibilityUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_accessibilite_application";

  // saved search
  static String createAlert = "Créer une alerte";
  static String createSavedSearchTitle = "Enregistrer la recherche en favoris";
  static String savedSearchTitle = "* Nom de la recherche";
  static String mandatorySavedSearchTitleError = "Renseigner un nom pour votre recherche";
  static String savedSearchFilters = "Critères de la recherche";
  static String createSavedSearchButton = "Créer une alerte";
  static String savedSearchInfo = "Les filtres appliqués seront aussi enregistrés.";
  static String searchNotificationInfo =
      "Vous recevrez des notifications pour être alerté des nouvelles offres liées aux critères de votre recherche.";

  static String savedSearchTitleField(metier, localisation) => "$metier - $localisation";
  static String savedSearchEmploiTag = "Offre d’emploi";
  static String savedSearchAlternanceTag = "Alternance";
  static String savedSearchImmersionTag = "Immersion";
  static String savedSearchSuccessfullyCreated =
      "Votre recherche a bien été enregistrée en favoris. Retrouvez-la dans la page favoris.";
  static String creationSavedSearchError = "Erreur lors de la création de la recherche sauvegardée. Veuillez réessayer";
  static String savedSearchGetError = "Erreur lors de la récupération des recherches sauvegardées.";
  static String noSavedSearchYet = "Aucune recherche sauvegardée.";
  static String savedSearchTabName = "Mes recherches";
  static String favorisTabName = "Mes offres";
  static String savedSearchSeeResults = "Voir les résultats";

  static String savedSearchDeleteMessage = "Voulez-vous vraiment supprimer la recherche sauvegardée ?";
  static String savedSearchDeleteCancel = "Annuler";
  static String savedSearchDeleteConfirm = "Supprimer";
  static String savedSearchDeleteError = "Erreur lors de la suppression de la recherche.";
  static String savedSearchDeleteSuccess = "Votre recherche sauvegardée a été supprimée avec succès.";
}
