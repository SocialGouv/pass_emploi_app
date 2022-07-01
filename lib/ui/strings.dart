class Strings {
  Strings._();

  // Common
  static String appName = "CEJ";
  static String retry = "Réessayer";
  static String logoTextDescription = "Logo CEJ";
  static String close = "Fermer";
  static String yes = "Oui";
  static String nouveau = "Nouveau";

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
  static String newConseillerTitle = "Vous échangez avec votre nouveau conseiller";
  static String newConseillerTemporaireTitle = "Vous échangez temporairement avec un nouveau conseiller";
  static String newConseillerDescription = "Il a accès à l’historique de vos échanges";
  static String unknownTypeTitle = "Le message est inaccessible";
  static String unknownTypeDescription = "Pour avoir l'accès au contenu veuillez mettre à jour l'application";
  static String voirOffre = "Voir l'offre";

  static String chatWith(firstName) => "Discuter avec $firstName";

  static String simpleDayFormat(day) => "Le $day";
  static String open = "Ouvrir";
  static String fileNotAvailableError = "ERROR: 404";
  static String fileNotAvailableTitle = "Les fichiers ne sont plus disponibles";

  // Force Update
  static String updateTitle = "Mise à jour";
  static String updateButton = "Mettre à jour";
  static String forceUpdateOnStoreLabel = "Votre application nécessite d'être mise à jour pour son bon fonctionnement";
  static String forceUpdateOnFirebaseLabel =
      "Votre application nécessite d'être mise à jour sur Firebase pour son bon fonctionnement";

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
  static String demarcheTabTitle = "Démarches";

  // Rendezvous
  static String myRendezVous = "Mon rendez-vous";
  static String rendezvousCardAnnule = "Annulé";
  static String rendezvousDetailsAnnule = "Rendez-vous annulé";
  static String rendezVousConseillerCommentLabel = "Commentaire de mon conseiller";
  static String cannotGoToRendezvous = "Vous ne pouvez pas vous rendre au rendez-vous ?";
  static String shouldInformConseiller =
      "En cas d’imprévu, il est important de prévenir votre conseiller. Vous pouvez le contacter via la messagerie de l’application CEJ.";

  static String noUpcomingRendezVous =
      "Vous n’avez pas de rendez-vous prévus.\nContactez votre conseiller pour prendre rendez-vous";
  static String rendezVousError = "Erreur lors de la récupération de vos rendez-vous";
  static String conseillerIsPresent = "Votre conseiller sera présent";
  static String conseillerIsNotPresent = "Votre conseiller ne sera pas présent";
  static String commentWithoutConseiller = "Commentaire de votre conseiller";
  static String seeItinerary = 'Voir l\'itinéraire';
  static String seeVisio = 'Accéder à la visio';
  static String rendezvousVisioModalityMessage =
      'Le rendez-vous se fera en visio. La visio sera disponible le jour du rendez-vous.';
  static String rendezVousPassesTitre = "Rendez-vous passés";
  static String rendezVousCetteSemaineTitre = "Cette semaine";
  static String rendezSemaineTitre = "Semaine du";
  static String rendezVousFutursTitre = "Rendez-vous futurs";
  static String noRendezVousCetteSemaineTitre = "Vous n'avez pas encore de rendez-vous prévus cette semaine";
  static String noRendezYet = "Vous n'avez pas encore de rendez-vous prévus";
  static String noMoreRendezVousThisWeek = "Vous n'avez pas d'autres rendez-vous prévus cette semaine.";
  static String noRendezYetSubtitle =
      "Vous pouvez consulter ceux passés et à venir en utilisant les flèches en haut de page.";
  static String noRendezAutreCetteSemainePrefix = "Vous n’avez pas encore de rendez-vous prévus pour la semaine du ";
  static String noRendezAvantCetteSemaine = "Vous n’avez pas encore de rendez-vous passés";
  static String noRendezVousFutur = "Vous n’avez pas encore de rendez-vous prévus";
  static String withConseiller = "avec";
  static String goToNextRendezvous = "Aller au prochain rendez-vous";
  static String seeMoreRendezvous = "Voir plus de rendez-vous";
  static String individualInterview = "Entretien individuel conseiller";
  static String publicInfo = "Information collective";

  static String rendezvousSinceDate(String date) => "depuis le $date";

  static String rendezvousStartingAtDate(String date) => "à partir du $date";

  static String rendezvousWithConseiller(String conseiller) => "votre conseiller $conseiller";

  static String rendezvousCreateur(String createur) {
    return "Le rendez-vous a été programmé par votre conseiller précédent $createur";
  }

  static String rendezvousModalityDetailsMessage(String modality) => "Le rendez-vous se fera $modality";

  static String rendezvousModalityCardMessage(String modality, String conseiller) => "$modality avec $conseiller";

  static String phone(String phone) => "Téléphone : $phone";

  static String withOrganism(String organism) => "Avec : $organism";

  // App evaluation
  static String evalTitle = "Votre expérience sur l’application";
  static String evalDescription = "Aidez-nous à améliorer l’application en répondant à 2 questions.";
  static String evalButton = "Donner son avis";

  static String questionIndexTitle(String index, String total) => "Votre expérience $index/$total";
  static String nextButtonTitle = "Suivant";
  static String validateButtonTitle = "Valider";
  static String mandatory = "Les questions marquées d'une * sont obligatoires";
  static String pourquoiTitle = "Pourquoi ?";
  static String evaluationSuccessfullySent = "Vous avez répondu aux questions, merci !";

  // User Action
  static String actionsError = "Erreur lors de la récupération de vos actions";
  static const String actionDone = "Terminée";
  static const String actionCanceled = "Annulée";
  static String aboutThisAction = "À propos de cette action";
  static String actionDetails = "Détail de l'action";
  static String demarcheDetails = "Détail de la démarche";
  static String updateStatus = "Changer le statut";
  static String refreshActionStatus = "Actualiser";
  static const String actionToDo = "À réaliser";
  static const String actionInProgress = "Commencée";
  static String noActionsYet = "Vous n'avez pas encore d’actions";
  static String addAnAction = "Créer une action";
  static String addAMessageError = "Vous avez dépassé le nombre de caractères autorisés";
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
  static String demarcheCreationSuccess = "La démarche a bien été créée";
  static String linkDetailsRendezVous = "Voir les détails du rendez-vous";

  static String lastUpdateFormat(String formattedDate) => "Modifiée le $formattedDate";
  static String doneActionsTitle = "Actions terminées et annulées";

  // Demarches
  static String modifierStatut = "Modifier le statut";
  static String historiqueDemarche = "Historique";
  static String modifiedBy = "Modifiée le ";
  static String createdBy = "Crée le ";
  static String par = " par ";
  static String votreConseiller = "votre conseiller";
  static const String demarcheToDo = "À faire";
  static const String demarcheInProgress = "En cours";
  static const String demarcheRetarded = "En retard";
  static const String demarcheDone = "Réalisé";
  static const String demarcheCancelled = "Annulé";
  static const String demarcheLate = "En retard : ";
  static const String createDemarchePersonnalisee = "Créer une démarche personnalisée";
  static const String mandatoryFields = "Les champs marqués d’une * sont obligatoires";
  static const String commentaire = "Commentaire";
  static const String descriptionDemarche = "*Description de la démarche";
  static const String caracteres255 = "255 caractères maximum";
  static const String quand = "Quand";
  static const String selectEcheance = "*Sélectionner une date d'échéance";
  static const String addADemarche = "Créer une démarche";
  static const String createDemarcheTitle = "Création d'une démarche";
  static const String noDemarcheFound = "Aucune démarche pre-renseignée n’a été trouvée";
  static const String selectDemarche = "Sélectionnez une démarche ou créez une démarche personnalisée";
  static const String addALaDemarche = "Créer la démarche";
  static const String searchDemarcheHint = "Renseigner un mot clé pour rechercher une démarche à créer";
  static const String searchDemarcheButton = "Rechercher une démarche";
  static const String mandatoryField = "Le champs est obligatoire";
  static const String comment = "Comment";
  static const String selectComment = "*Sélectionner un des moyens";
  static const String selectQuand = "*Sélectionner une date d’échéance";

  static String demarcheActiveDateFormat(String formattedDate) => "À réaliser pour le $formattedDate";

  static String demarcheDoneDateFormat(String formattedDate) => "Réalisé le $formattedDate";

  static String demarcheCancelledDateFormat(String formattedDate) => "Annulé le $formattedDate";
  static String withoutDate = "Date indéterminée";
  static String withoutContent = "Démarche indéterminée";
  static String createByAdvisor = "Créé par votre conseiller";

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
  static String partagerOffreConseiller = "Partager l’offre à mon conseiller";
  static String partageOffreNavTitle = "Partage de l’offre d’emploi";
  static String souhaitDePartagerOffre = "L’offre que vous souhaitez partager";
  static String messagePourConseiller = "Message destiné à votre conseiller";
  static String offrePartageChat = "L’offre d’emploi sera partagée à votre conseiller dans la messagerie";
  static String partagerOffreEmploi = "Partager l’offre d’emploi";

  // Alternance
  static String alternanceButton = "Alternance";
  static String alternanceTitle = "Offres d'alternance";

  // Immersion
  static String immersionLabel = "Découvrez un métier en immersion dans une entreprise.";
  static String metierCompulsoryLabel = "* Métier";
  static String villeCompulsoryLabel = "* Localisation";
  static String villeNonCompulsoryLabel = "Localisation";
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
  static String immersionLocationButton = "Localiser l'entreprise";
  static String immersionEmailButton = "Envoyer un e-mail";
  static String immersionEmailSubject = "Candidature pour une période d'immersion";

  // Civic Service
  static String serviceCiviqueTitle = "Qu’est-ce que le service civique ?";
  static String serviceCiviqueContent =
      "Le service civique est un engagement volontaire au service de l'intérêt général, accessible sans condition de diplôme. Il est indemnisé et s'effectue en France ou à l'étranger.";
  static String serviceCiviqueButtonAction = "Rechercher un service civique";
  static String serviceCiviqueUrl = "https://www.service-civique.gouv.fr/missions/";
  static String serviceCiviquePresentation =
      "Engagez-vous dans un projet d’intérêt général et découvrez de nouveaux horizons";
  static String serviceCiviqueFiltresTitle = "Filtrer les missions";
  static String startDateFiltreTitle = "Date de début";
  static String startDate = "Dès le";
  static String domainFiltreTitle = "Domaine";
  static String selectACity = "Sélectionner une ville";
  static String knowMoreAboutServiceCivique = "En savoir plus sur le service civique";
  static String knowMoreAboutServiceCiviqueFirstTitle = "De 16 à 25 ans";
  static String knowMoreAboutServiceCiviqueFirstText =
      "Les missions sont ouvertes à tous les jeunes de 16 à 25 ans, sans conditions de diplôme et jusqu’à 30 ans pour les jeunes en situation de handicap";
  static String knowMoreAboutServiceCiviqueSecondTitle = "De 6 à 12 mois";
  static String knowMoreAboutServiceCiviqueSecondText =
      "Tous les organismes proposant des missions de Service Civique sont certifiés d’intérêt général et œuvrent dans 9 domaines différents";
  static String knowMoreAboutServiceCiviqueThirdTitle = "En France et à l’étranger";
  static String knowMoreAboutServiceCiviqueThirdText =
      "Découvrir de nouvelles expériences, acquérir de nouvelles compétences tout en étant indemnisé et en bénéficiant de nombreux avantages";
  static String knowMoreAboutServiceCiviqueFourthTitle = "Une indemnisation";
  static String knowMoreAboutServiceCiviqueFourthText =
      "580 € d’indemnisation par mois dont 473,04 € pris en charge par l’État et 107,58 € par l’organisme d’accueil. ";
  static String knowMoreAboutServiceCiviqueLastTitle =
      "Vous souhaitez en savoir plus ? Envoyez un message à votre conseiller.";
  static String serviceCiviqueListTitle = "Offres de service civique";
  static String asSoonAs = "Dès le ";
  static String serviceCiviqueDetailTitle = "Détails de l’offre de service civique";
  static String serviceCiviqueMissionTitle = "Mission";
  static String serviceCiviqueOrganisationTitle = "Organisation";

  // Immersion Errors
  static String immersionMetierError = "Renseignez un secteur d'activité de la liste";
  static String immersionVilleError = "Renseignez une ville de la liste";

  // Solutions Errors
  static String noContentError =
      "Pour le moment, aucune offre ne correspond à vos critères.\n\nTrouvez d'autres offres en modifiant vos critères.";
  static String genericError = "Erreur lors de la recherche. Veuillez réessayer";
  static String genericCreationError = "Erreur lors de la création. Veuillez réessayer";
  static String loadMoreOffresError = "Erreur lors du chargement des offres";
  static String updateCriteria = "Modifier les critères de recherche";

  // Offre emploi filtres
  static String filtrer = "Filtrer";
  static String offresEmploiFiltresTitle = "Filtrer les annonces";
  static String searchRadius = "Dans un rayon de : ";
  static String applyFiltres = "Appliquer les filtres";

  static String kmFormat(int int) => "$int km";
  static String experienceSectionTitle = "Expérience";
  static String experienceSectionDescription = "Afficher uniquement les offres débutants acceptés";
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

  // Empty Content (actions & rdv)
  static String rendezvous = "rendez-vous";
  static String actions = "actions";
  static String demarchesToDo = "démarches à réaliser.";
  static String demarches = "démarches";

  static String poleEmploiUrlButton = "Accéder à mon espace Pôle emploi";
  static String espacePoleEmploiUrl = "https://candidat.pole-emploi.fr/espacepersonnel/";

  static String emptyContentTitle(String content) => "Vous n’avez pas encore de $content";

  static String emptyContentDescription(String content) =>
      "Vous pouvez créer vos $content en autonomie depuis votre espace Pôle emploi.";

  // Profil
  static String personalInformation = "Informations personnelles";

  static String sinceDate(String date) => "Depuis le $date";
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

  // Profil: Settings & account suppression
  static String settingsLabel = "Paramètres application";
  static String suppressionPageTitle = "Suppression de compte";
  static String suppressionAccountLabel = "Supprimer mon compte de l’application CEJ";
  static String warning = "Attention";
  static String suppressionButtonLabel = "Supprimer mon compte";
  static String warningInformationParagraph1 =
      "En supprimant votre compte de l’application Contrat d’Engagement Jeune, vous perdrez définitivement toutes les données présentes sur l’application :";
  static String warningInformationParagraph2 =
      "La suppression de votre compte sur l’application CEJ n'entraine pas la suppression de votre accompagnement dans le cadre du Contrat d'Engagement Jeune.";
  static String warningInformationPoleEmploi =
      "Vos démarches et rendez-vous seront toujours disponibles dans votre portail Pôle emploi.";
  static List<String> warningPointsMilo = [
    "vos actions",
    "vos messages avec votre conseiller",
    "vos rendez-vous",
    "vos recherches et offres sauvergardées"
  ];

  static List<String> warningPointsPoleEmploi = [
    "vos messages avec votre conseiller",
    "vos recherches et offres sauvergardées"
  ];
  static String lastWarningBeforeSuppression = "Tapez “supprimer” pour confirmer la suppression de votre compte";
  static String mandatorySuppressionLabelError = "Vérifiez que vous avez bien tapé “supprimer”";
  static String accountDeletionSuccess = "Votre compte a bien été supprimé de l’application CEJ";

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
  static String savedSearchServiceCiviqueTag = "Service civique";
  static String savedSearchSuccessfullyCreated =
      "Votre recherche a bien été enregistrée en favoris. Retrouvez-la dans la page favoris.";
  static String creationSavedSearchError = "Erreur lors de la création de la recherche sauvegardée. Veuillez réessayer";
  static String savedSearchGetError = "Erreur lors de la récupération des recherches sauvegardées.";
  static String noSavedSearchYet = "Aucune recherche sauvegardée.";
  static String savedSearchTabName = "Mes recherches";
  static String favorisTabName = "Mes offres";
  static String savedSearchSeeResults = "Voir les résultats";

  static String savedSearchDeleteMessage = "Voulez-vous vraiment supprimer la recherche sauvegardée ?";
  static String cancelLabel = "Annuler";
  static String suppressionLabel = "Supprimer";
  static String savedSearchDeleteError = "Erreur lors de la suppression de la recherche.";
  static String savedSearchDeleteSuccess = "Votre recherche sauvegardée a été supprimée avec succès.";

  // Mode démo
  static String modeDemoAppBarLabel = "Version démo conseiller";
  static String modeDemoExplicationTitre = "Espace démo conseiller";
  static String modeDemoExplicationPremierPoint1 = "→ Cette version vous ";
  static String modeDemoExplicationPremierPoint2 = "permet d’explorer";
  static String modeDemoExplicationPremierPoint3 = " l’application CEJ utilisée par vos bénéficiaires.";
  static String modeDemoExplicationSecondPoint1 = "→ Les données présentées ";
  static String modeDemoExplicationSecondPoint2 = "sont factices.";
  static String modeDemoExplicationTroisiemePoint1 =
      "→ Vous pourrez naviguer dans l'application, rédiger des messages (sans les envoyer) et effectuer des recherches. Les résultats alors affichés sont ";
  static String modeDemoExplicationTroisiemePoint2 =
      "donnés à titre d’exemples et ne correspondent pas aux recherches effectuées.";
  static String modeDemoExplicationChoix = "Veuillez sélectionner le mode de démonstration";

  // Campagne
  static String campagneTitle(int page, int count) => "Votre expérience $page/$count";

  // Developer options
  static String developerOptions = 'Options développeurs';
  static String developerOptionMatomo = 'Données envoyées à Matomo';
  static String developerOptionMatomoPage = 'Matomo';
}
