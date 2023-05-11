import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/ui/immersion_contacts_strings.dart';

class _BrsaStrings {
  static String appName = "pass emploi";
  static String logoDescription = "Logo pass emploi";
  static String shouldInformConseiller =
      "En cas d’imprévu, il est important de prévenir votre conseiller. Vous pouvez le contacter via la messagerie de l’application pass emploi.";
  static String suppressionAccountLabel = "Supprimer mon compte de l’application pass emploi";
  static String warningInformationParagraph1 =
      "En supprimant votre compte de l’application pass emploi, vous perdrez définitivement toutes les données présentes sur l’application :";
  static String warningInformationParagraph2 =
      "La suppression de votre compte sur l’application pass emploi n'entraîne pas la suppression de votre accompagnement.";
  static String accountDeletionSuccess = "Votre compte a bien été supprimé de l’application pass emploi";
  static String modeDemoExplicationPremierPoint3 = " l’application pass emploi utilisée par vos bénéficiaires.";
  static String ratingLabel = "Aimez-vous l’application pass emploi ?";
  static String legalNoticeUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/pass_emploi_mentions_legales";
  static String privacyPolicyUrl =
      "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_pass_emploi_politique_de_confidentialite";
  static String termsOfServiceUrl =
      "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_pass_emploi_conditions_generales";
  static String accessibilityUrl =
      "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_pass_emploi_accessibilite_application";
}

class _CejStrings {
  static String appName = "CEJ";
  static String logoDescription = "Logo CEJ";
  static String shouldInformConseiller =
      "En cas d’imprévu, il est important de prévenir votre conseiller. Vous pouvez le contacter via la messagerie de l’application CEJ.";
  static String suppressionAccountLabel = "Supprimer mon compte de l’application CEJ";
  static String warningInformationParagraph1 =
      "En supprimant votre compte de l’application CEJ, vous perdrez définitivement toutes les données présentes sur l’application :";
  static String warningInformationParagraph2 =
      "La suppression de votre compte sur l’application CEJ n'entraîne pas la suppression de votre accompagnement.";
  static String accountDeletionSuccess = "Votre compte a bien été supprimé de l’application CEJ";
  static String modeDemoExplicationPremierPoint3 = " l’application CEJ utilisée par vos bénéficiaires.";
  static String ratingLabel = "Aimez-vous l’application CEJ ?";
  static String legalNoticeUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_mentions_legales";
  static String privacyPolicyUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_politique_de_confidentialite";
  static String termsOfServiceUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_conditions_generales";
  static String accessibilityUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_accessibilite_application";
}

class Strings {
  Strings._();

  static String according({
    required LoginMode loginMode,
    required int count,
    required String singularPoleEmploi,
    required String severalPoleEmploi,
    required String singularMissionLocale,
    required String severalMissionLocale,
  }) {
    return loginMode.isPe()
        ? count <= 1
            ? singularPoleEmploi
            : severalPoleEmploi
        : count <= 1
            ? singularMissionLocale
            : severalMissionLocale;
  }

  // Common
  static String appName = Brand.isCej() ? _CejStrings.appName : _BrsaStrings.appName;
  static String retry = "Réessayer";
  static String logoDescription = Brand.isCej() ? _CejStrings.logoDescription : _BrsaStrings.logoDescription;
  static String close = "Fermer";
  static String yes = "Oui";
  static String no = "Non";
  static String ajouter = "Ajouter";
  static String cancelLabel = "Annuler";
  static String suppressionLabel = "Supprimer";
  static String seeDetail = "Voir le détail >";
  static String voirLeDetail = "Voir le détail";
  static String copie = "Copié";

  // Menu
  static String menuAccueil = "Accueil";
  static String menuMonSuivi = "Mon suivi";
  static String menuChat = "Messages";
  static String menuSolutions = "Recherche";
  static String menuFavoris = "Favoris";
  static String menuRendezvous = "Rendez-vous";
  static String menuProfil = "Mon profil";
  static String menuEvenements = "Événements";

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
  static String voirEvent = "Voir l'évènement";

  static String chatWith(firstName) => "Discuter avec $firstName";

  static String simpleDayFormat(day) => "Le $day";
  static String open = "Ouvrir";
  static String fileNotAvailableError = "ERROR: 404";
  static String fileNotAvailableTitle = "Le fichier n'est plus disponible";

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

  // Accueil
  static String accueilAppBarTitle = "Bienvenue";
  static String accueilCetteSemaineSection = "Cette semaine";
  static String accueilVoirDetailsCetteSemaine = "Voir le détail de ma semaine";

  static String rendezvousEnCours(int count) => "$count rendez-vous";

  static String singularDemarcheToDo(int count) => "$count démarche à réaliser";

  static String severalDemarchesToDo(int count) => "$count démarches à réaliser";

  static String singularActionToDo(int count) => "$count action à réaliser";

  static String severalActionsToDo(int count) => "$count actions à réaliser";

  static String singularDemarcheLate(int count) => "$count démarche en retard";

  static String severalDemarchesLate(int count) => "$count démarches en retard";

  static String singularActionLate(int count) => "$count action en retard";

  static String severalActionsLate(int count) => "$count actions en retard";
  static String accueilRendezvousSection = "Votre prochain rendez-vous";
  static String accueilEvenementsSection = "Événements à venir";
  static String accueilVoirLesEvenements = "Voir tous les événements";
  static String accueilMesAlertesSection = "Mes alertes";
  static String accueilVoirMesAlertes = "Voir toutes mes alertes";
  static String accueilPasDalerteDescription =
      "Créez des alertes lors de vos recherches et recevez les offres qui vous correspondent";
  static String accueilPasDalerteBouton = "Rechercher une offre";
  static String accueilMesFavorisSection = "Mes favoris";
  static String accueilVoirMesFavoris = "Voir tous mes favoris";
  static String accueilPasDeFavorisDescription = "Retrouvez ici les offres que vous avez enregistrées";
  static String accueilPasDeFavorisBouton = "Rechercher une offre";
  static String accueilOutilsSection = "Boîte à outils";
  static String accueilOutilsSectionDescription = "Découvrez des outils pour vous aider dans vos projets";
  static String accueilVoirLesOutils = "Voir tous les outils";

  // Mon Suivi
  static String monSuiviAppBarTitle = "Mon suivi";
  static String agendaTabTitle = "Cette semaine";
  static String actionsTabTitle = "Actions";
  static String rendezvousTabTitle = "Rendez-vous";
  static String demarcheTabTitle = "Démarches";

  // Agenda
  static String agendaEmptyMilo = "Vous n'avez pas encore d'actions ni de rendez-vous prévus cette semaine.";
  static String agendaEmptyPoleEmploi = "Vous n'avez pas encore de démarches ni de rendez-vous prévus cette semaine.";
  static String agendaError = "Erreur lors de la récupération de vos actions et rendez-vous";
  static String agendaEmptyForDayMilo = "Pas d’action ni de rendez-vous";
  static String agendaEmptyForDayPoleEmploi = "Pas de démarche ni de rendez-vous";
  static String nextWeek = "Semaine prochaine";
  static String semaineEnCours = "Semaine en cours";
  static String agendaNoActionThisWeekTitle = "Vous n’avez pas d’action ni de rendez-vous prévus cette semaine";
  static String agendaNoActionThisWeekDescription = "Vous pouvez voir les événements à venir dans votre Mission locale";
  static String agendaSeeEventInAgenceButton = "Voir les événements de votre mission locale";

  // Actualisation PE
  static String actualisationPePopUpTitle = "La période d’actualisation Pôle emploi a commencé";
  static String actualisationPePopUpSubtitle = "Pensez à vous actualiser avant le 15 du mois";
  static String actualisationPePopUpPrimaryButton = "S'actualiser";
  static String actualisationPePopUpSecondaryButton = "Fermer";

  // Rendezvous
  static String eventTitle = "Événement";
  static String myRendezVous = "Mon rendez-vous";
  static String rendezvousCardAnnule = "Annulé";
  static String rendezvousDetailsAnnule = "Rendez-vous annulé";
  static String rendezVousConseillerCommentLabel = "Commentaire de mon conseiller";
  static String cannotGoToRendezvous = "Vous ne pouvez pas vous rendre au rendez-vous ?";
  static String shouldInformConseiller =
      Brand.isCej() ? _CejStrings.shouldInformConseiller : _BrsaStrings.shouldInformConseiller;

  static String noUpcomingRendezVous =
      "Vous n’avez pas de rendez-vous prévus.\nContactez votre conseiller pour prendre rendez-vous";
  static String rendezVousListError = "Erreur lors de la récupération de vos rendez-vous";
  static String rendezVousDetailsError = "Erreur lors de la récupération de l'évènement";
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
  static String shareToConseiller = "Partager à mon conseiller";

  static String rendezvousSinceDate(String date) => "depuis le $date";

  static String rendezvousStartingAtDate(String date) => "à partir du $date";

  static String rendezvousWithConseiller(String conseiller) => "votre conseiller $conseiller";

  static String rendezvousCreateur(String createur) {
    return "Le rendez-vous a été programmé par votre conseiller précédent $createur";
  }

  static String rendezvousModalityDetailsMessage(String modality) => "Le rendez-vous se fera $modality";

  static String rendezvousModalityCardMessage(String modality, String conseiller) => "$modality avec $conseiller";

  static String phone(String phone) => "Téléphone : $phone";

  // App evaluation
  static String evalTitle = "Votre expérience sur l’application";
  static String evalDescription = "Aidez-nous à améliorer l’application en répondant à quelques questions.";
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
  static String updateStatus = "Modifier le statut";
  static String refreshActionStatus = "Valider le statut";
  static const String actionToDo = "À réaliser";
  static const String actionInProgress = "Commencée";
  static String noActionsYet = "Vous n'avez pas encore d’actions.";
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
  static String createActionSuccess = "Votre action a bien été créée.";
  static String createDemarcheSuccess = "La démarche a bien été créée";
  static String linkDetailsRendezVous = "Voir les détails du rendez-vous";

  static String dateEcheanceFormat(String formattedDate) => "À réaliser pour le $formattedDate";
  static String doneActionsTitle = "Actions terminées et annulées";
  static String rappelSwitch = 'Recevoir une notification de rappel 3 jours avant l’échéance';

  static String numberOfActions(int count) => "$count actions";

  static String numberOfDemarches(int count) => "$count démarches";
  static String see = "Voir";

  // Commentaires d'action
  static String actionCommentsTitle = "Commentaire de l’action";
  static String lastComment = "Dernier commentaire";
  static String noComments = "Vous n’avez pas encore de commentaire";

  static String createdByAdvisor(String advisor) => "Votre conseiller $advisor";
  static String addComment = "Ajouter un commentaire";

  static String seeNComments(String n) => "Voir les $n commentaires";
  static String yourComment = "Votre commentaire...";
  static String sendCommentError = "Erreur lors de l'envoi du commentaire. Veuillez réessayer";

  // Demarches
  static String demarchesError = "Erreur lors de la récupération de vos démarches";
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
  static const String late = "En retard : ";
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

  static String demarcheActiveLabel = "À réaliser pour le ";

  static String demarcheActiveDateFormat(String formattedDate) => demarcheActiveLabel + formattedDate;

  static String demarcheDoneLabel = "Réalisé le ";

  static String demarcheDoneDateFormat(String formattedDate) => demarcheDoneLabel + formattedDate;

  static String demarcheCancelledLabel = "Annulé le ";

  static String demarcheCancelledDateFormat(String formattedDate) => demarcheCancelledLabel + formattedDate;

  static String updateStatusError = "Erreur lors du changement du statut. Veuillez réessayer";

  static String withoutDate = "Date indéterminée";
  static String withoutContent = "Démarche indéterminée";
  static String createByAdvisor = "Créé par votre conseiller";

  // Recherche
  static String derniereRecherche = "Dernière recherche";
  static String dernieresRecherches = "Dernières recherches";
  static String vosPreferencesMetiers = "Vos préférences métiers";
  static String rechercheHomeNosOffres = "Nos offres";
  static String rechercheHomeCardLink = "Rechercher";
  static String rechercheHomeOffresEmploiTitle = "Offres d’emploi";
  static String rechercheHomeOffresEmploiSubtitle = "Trouvez un emploi qui vous correspond.";
  static String rechercheHomeOffresAlternanceTitle = "Offres d’alternance";
  static String rechercheHomeOffresAlternanceSubtitle =
      "Professionnalisez-vous en associant travail en entreprise et formation.";
  static String rechercheHomeOffresImmersionTitle = "Offres d’immersion";
  static String rechercheHomeOffresImmersionSubtitle = "Découvrez un métier au sein d’une entreprise.";
  static String rechercheHomeOffresServiceCiviqueTitle = "Offres de service civique";
  static String rechercheHomeOffresServiceCiviqueSubtitle =
      "Engagez-vous dans une mission d’intérêt général pour aider les autres.";
  static String rechercheOffresEmploiTitle = "Offres d’emploi";
  static String rechercheOffresAlternanceTitle = "Offres d’alternance";
  static String rechercheOffresImmersionTitle = "Offres d’immersion";
  static String rechercheOffresServiceCiviqueTitle = "Offres de service civique";
  static String rechercheLancerUneRechercheHint = "Lancez une recherche pour afficher les offres vous correspondant";
  static String rechercheAfficherPlus = "Afficher plus d'offres";

  static String rechercheCriteresActifsSingular(int count) => "($count) critère actif";

  static String rechercheCriteresActifsPlural(int count) => "($count) critères actifs";

  // Solutions
  static String keywordTitle = "Mot clé";
  static String keywordEmploiHint = "Saisissez un métier, une compétence, un secteur d'activité…";
  static String keywordAlternanceHint = "Saisissez un métier, une compétence, un secteur d'activité…";
  static String metierMandatoryLabel = "*Métier";
  static String metierImmersionHint = "Renseignez le métier pour lequel vous souhaitez faire une immersion.";
  static String jobLocationTitle = "Localisation";
  static String jobLocationMandatoryTitle = "*Localisation";
  static String jobLocationEmploiHint = "Sélectionnez une ville ou un département dans lequel vous cherchez un emploi.";
  static String jobLocationAlternanceHint =
      "Sélectionnez une ville ou un département dans lequel vous cherchez une alternance.";
  static String jobLocationImmersionHint = "Sélectionnez une ville dans laquelle vous cherchez une immersion.";
  static String jobLocationServiceCiviqueHint =
      "Sélectionnez une ville dans laquelle vous cherchez un service civique.";
  static String searchButton = "Rechercher";
  static String offreDetails = "Détails de l'offre";
  static String offresTabTitle = "Offres";
  static String boiteAOutilsTabTitle = "Boîte à outils";
  static String solutionsAppBarTitle = "Recherche";
  static String partagerOffreConseiller = "Partager l’offre à mon conseiller";
  static String partageOffreNavTitle = "Partage de l’offre d’emploi";
  static String souhaitDePartagerOffre = "L’offre que vous souhaitez partager";
  static String partageOffreDefaultMessage = "Bonjour, je vous partage une offre d’emploi afin d’avoir votre avis";
  static String partageOffreSuccess =
      "L’offre d’emploi a été partagée à votre conseiller sur la messagerie de l’application";
  static String messagePourConseiller = "Message destiné à votre conseiller";
  static String infoOffrePartageChat = "L’offre d’emploi sera partagée à votre conseiller dans la messagerie";
  static String partagerOffreEmploi = "Partager l’offre d’emploi";

  // Alternance
  static String partagerOffreAlternance = "Partager l’offre d’alternance";
  static String partageOffreAlternanceNavTitle = "Partage de l’offre d’alternance";

  // Event partage
  static String infoEventPartageChat = "L’événement sera partagé à votre conseiller dans la messagerie";
  static String souhaitDePartagerEvent = "Ce que vous souhaitez partager";
  static String partageEventDefaultMessage = "Bonjour, je vous partage un événement afin d’avoir votre avis";
  static String partagerAuConseiller = "Partager à mon conseiller";
  static String partageEventNavTitle = "Partage d’événement";
  static String partageEventSuccess = "L’événement a été partagé à votre conseiller sur la messagerie de l’application";

  // Immersion
  static String entrepriseAccueillante = 'Entreprise accueillante';
  static String entreprisesAccueillantesHeader =
      'Les entreprises accueillantes facilitent vos immersions professionnelles';
  static String immersionExpansionTileTitle = "En savoir plus sur l’immersion";
  static String immersionNonAccueillanteExplanation =
      "Cette entreprise peut recruter sur ce métier et être intéressée pour vous recevoir en immersion. Contactez-la en expliquant votre projet professionnel et vos motivations.";
  static String immersionAccueillanteExplanation =
      "Cette entreprise recherche activement des candidats à l’immersion. Contactez-la en expliquant votre projet professionnel et vos motivations.";
  static String immersionDescriptionLabel = "Si l’entreprise est d’accord pour vous accueillir :\n\n"
      "· Prévenez votre conseiller\n"
      "· Remplissez une convention d’immersion avec lui";
  static String immersionContactBlocTitle = "Contact";
  static String immersionPhoneButton = "Appeler";
  static String immersionLocationButton = "Localiser l'entreprise";
  static String immersionEmailButton = "Envoyer un e-mail";
  static String immersionEmailSubject = "Candidature pour une période d'immersion";
  static String immersionContactSucceed = "Votre message a bien été transmis à l'entreprise.";
  static String immersionContact = "Contacter";
  static String immersitionContactFormTitle = "Contacter l’entreprise";
  static String immersitionContactFormSubtitle = "Veuillez compléter ce formulaire qui sera transmis à l'entreprise.";
  static String immersitionContactFormHint = "Tous les champs avec * sont obligatoires";
  static String immersitionContactFormEmailHint = "Email";
  static String immersitionContactFormSurnameHint = "Prénom";
  static String immersitionContactFormNameHint = "Nom";
  static String immersitionContactFormMessageHint = "Message";
  static String immersitionContactFormMessageDefault =
      "Bonjour, Je souhaiterais passer quelques jours dans votre entreprise en immersion professionnelle auprès de vos salariés pour découvrir ce métier.\nPourriez-vous me proposer un rendez-vous ? \nJe pourrais alors vous expliquer directement mon projet.";
  static String immersionContactFormButton = "Envoyer";
  static String immersionContactFormEmailEmpty = "Renseignez votre adresse email";
  static String immersionContactFormEmailInvalid =
      "Veuillez renseigner une adresse email valide au format exemple@email.com";
  static String immersionContactFormFirstNameInvalid = "Renseignez votre prénom";
  static String immersionContactFormLastNameInvalid = "Renseignez votre nom";
  static String immersionContactFormMessageInvalid = "Renseignez votre message";
  static const immersionDataWarningMessage =
      "Veuillez utiliser les coordonnées de l'entreprise uniquement pour votre usage personnel";
  static String immersionContactTitle = ImmersionContactStrings.title;
  static String immersionContactSubtitle1 = ImmersionContactStrings.subtitle1;
  static String immersionContactBody1_1 = ImmersionContactStrings.body1_1;
  static String immersionContactBody1_2bold = ImmersionContactStrings.body1_2bold;
  static String immersionContactBody1_3 = ImmersionContactStrings.body1_3;
  static String immersionContactBody1_4bold = ImmersionContactStrings.body1_4bold;
  static String immersionContactBody1_5 = ImmersionContactStrings.body1_5;
  static String immersionContactBody1_6 = ImmersionContactStrings.body1_6;
  static String immersionContactBody1_7bold = ImmersionContactStrings.body1_7bold;
  static String immersionContactBody1_8 = ImmersionContactStrings.body1_8;
  static String immersionContactBody1_9bold = ImmersionContactStrings.body1_9bold;
  static String immersionContactBody1_10 = ImmersionContactStrings.body1_10;
  static String immersionContactBody1_11 = ImmersionContactStrings.body1_11;
  static String immersionContactBody1_12 = ImmersionContactStrings.body1_12;
  static String immersionContactSubtitle2 = ImmersionContactStrings.subtitle2;
  static String immersionContactBody2 = ImmersionContactStrings.body2;
  static String immersionContactSubtitle3 = ImmersionContactStrings.subtitle3;
  static String immersionContactBody3 = ImmersionContactStrings.body3;
  static String immersionContactSubtitle4 = ImmersionContactStrings.subtitle4;
  static String immersionContactBody4 = ImmersionContactStrings.body4;

  // Service Civique
  static String serviceCiviqueFiltresTitle = "Filtrer les missions";
  static String startDateFiltreTitle = "Date de début";
  static String startDate = "Dès le";
  static String domainFiltreTitle = "Domaine";
  static String asSoonAs = "Dès le ";
  static String serviceCiviqueDetailTitle = "Détails de l’offre de service civique";
  static String serviceCiviqueMissionTitle = "Mission";
  static String serviceCiviqueOrganisationTitle = "Organisation";

  // Solutions Errors
  static String noContentError =
      "Pour le moment, aucune offre ne correspond à vos critères.\n\nTrouvez d'autres offres en modifiant vos critères.";
  static String genericError = "Erreur lors de la recherche. Veuillez réessayer";
  static String genericCreationError = "Erreur lors de la création. Veuillez réessayer";

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
  static String mesFavorisTabTitle = "Mes favoris";
  static String mesAlertesTabTitle = "Mes alertes";
  static String miscellaneousErrorRetry = "Une erreur est survenue. Veuillez réessayer";
  static String offreDetailNumber(String offreId) => "Offre n°$offreId";
  static String offreDetailLastUpdate(String lastUpdate) => "Actualisée le $lastUpdate";
  static String noFavoris = "Aucun favori";
  static String favorisError = "Erreur lors de la récupération de vos favoris";
  static String favorisUnknownContractType = 'Type de contrat inconnu';
  static String favorisUnknownSecteur = 'Secteur d\'activité inconnu';

  // Offre Filter Page
  static String filterList = "Filtrer la liste";
  static String filterByType = "Filtrer par type";
  static String filterAll = "Tous";
  static String filterEmploi = "Emploi";
  static String filterImmersion = "Immersion";
  static String filterAlternance = "Alternance";
  static String filterServiceCivique = "Service civique";

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

  static String legalNoticeUrl = Brand.isCej() ? _CejStrings.legalNoticeUrl : _BrsaStrings.legalNoticeUrl;
  static String privacyPolicyUrl = Brand.isCej() ? _CejStrings.privacyPolicyUrl : _BrsaStrings.privacyPolicyUrl;
  static String termsOfServiceUrl = Brand.isCej() ? _CejStrings.termsOfServiceUrl : _BrsaStrings.termsOfServiceUrl;
  static String accessibilityUrl = Brand.isCej() ? _CejStrings.accessibilityUrl : _BrsaStrings.accessibilityUrl;

  // Profil: Settings & account suppression
  static String settingsLabel = "Paramètres application";
  static String suppressionPageTitle = "Suppression de compte";
  static String suppressionAccountLabel =
      Brand.isCej() ? _CejStrings.suppressionAccountLabel : _BrsaStrings.suppressionAccountLabel;
  static String activityShareLabel = "Partage de votre activité";
  static String activityShareDescription =
      "Autorisez le partage pour permettre au conseiller d’avoir un suivi de votre activité.";
  static String warning = "Attention";
  static String suppressionButtonLabel = "Supprimer mon compte";
  static String warningInformationParagraph1 =
      Brand.isCej() ? _CejStrings.warningInformationParagraph1 : _BrsaStrings.warningInformationParagraph1;
  static String warningInformationParagraph2 =
      Brand.isCej() ? _CejStrings.warningInformationParagraph2 : _BrsaStrings.warningInformationParagraph2;
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
  static String accountDeletionSuccess =
      Brand.isCej() ? _CejStrings.accountDeletionSuccess : _BrsaStrings.accountDeletionSuccess;

  static String shareFavoriteLabel = "Partager mes favoris";

  static String helpTitle = "Besoin d’aide ?";
  static String ratingAppLabel = "Partager votre avis sur l'application";

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
      "Votre recherche a bien été enregistrée. Retrouvez-la dans la section Mes Alertes sur votre page d'accueil.";
  static String creationSavedSearchError = "Erreur lors de la création de la recherche sauvegardée. Veuillez réessayer";
  static String savedSearchGetError = "Erreur lors de la récupération des recherches sauvegardées.";
  static String noSavedSearchYet = "Aucune recherche sauvegardée.";
  static String savedSearchTabName = "Mes alertes";
  static String favorisTabName = "Mes offres";
  static String savedSearchSeeResults = "Voir les résultats";

  static String savedSearchDeleteMessage = "Voulez-vous vraiment supprimer la recherche sauvegardée ?";
  static String savedSearchDeleteError = "Erreur lors de la suppression de la recherche.";
  static String savedSearchDeleteSuccess = "Votre recherche sauvegardée a été supprimée avec succès.";

  // Mode support
  static String supportInformations = "Infos pour le support";

  // Mode démo
  static String passerEnDemo = "Passer en mode démo";
  static String modeDemoAppBarLabel = "Version démo conseiller";
  static String modeDemoExplicationTitre = "Espace démo conseiller";
  static String modeDemoExplicationPremierPoint1 = "→ Cette version vous ";
  static String modeDemoExplicationPremierPoint2 = "permet d’explorer";
  static String modeDemoExplicationPremierPoint3 =
      Brand.isCej() ? _CejStrings.modeDemoExplicationPremierPoint3 : _BrsaStrings.modeDemoExplicationPremierPoint3;
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

  // Tutorial
  static String seeLater = "Voir plus tard";
  static String finish = "Terminer";

  //Appstore rating
  static String ratingLabel = Brand.isCej() ? _CejStrings.ratingLabel : _BrsaStrings.ratingLabel;
  static String positiveRating = "Oui ! \nBeau boulot, j’adore l’app.";
  static String negativeRating = "Non... \nJ’ai quelques remarques.";
  static String happyEmoji = "😍";
  static String sadEmoji = "😫";

  static String supportMail = "support@pass-emploi.beta.gouv.fr";
  static String titleSupportMail = "Mon avis sur l’application";
  static String contentSupportMail = "Aidez-nous à améliorer l’application en nous donnant votre avis :\n";

  // Suggestions de recherche
  static String vosSuggestionsDeRecherche = "Vos recherches suggérées";
  static String nouvellesSuggestionsDeRechercheTitre = "Vous avez de nouvelles recherches suggérées !";
  static String nouvellesSuggestionsDeRechercheDescription =
      "Sur la base de votre profil Pôle emploi, voici des suggestions de recherches à sauvegarder dans vos favoris";
  static String voirSuggestionsDeRecherche = "Voir les suggestions";
  static String suggestionsDeRechercheTitlePage = "Vos recherches suggérées";
  static String suggestionTypeEmploi = "Emploi";
  static String suggestionTypeAlternance = "Alternance";
  static String suggestionTypeImmersion = "Immersion";
  static String suggestionTypeServiceCivique = "Service civique";
  static String suggestionRechercheAjoutee = "Recherche ajoutée";
  static String suggestionRechercheAjouteeDescription = "La recherche a été ajoutée à vos favoris";
  static String voirResultatsSuggestion = "Voir les résultats";

  // Événements
  static String eventListError = "Erreur lors de la récupération des événements";
  static String eventListEmpty = "Il n'y a actuellement aucun événement";
  static String eventListHeaderText = "Retrouver ici l’ensemble des événements organisés par votre Mission locale";
  static String eventVousEtesDejaInscrit = "Vous êtes déjà inscrit";
  static String eventAppBarTitle = "Événements";

  // Mode dégradé Pôle Emploi
  static String rendezvousUpToDate = "Vos rendez-vous sont à jour";
  static String rendezvousNotUpToDateMessage =
      "Une erreur technique s’est produite. Certains de vos rendez-vous ne sont peut-être pas à jour.";
  static String demarchesUpToDate = "Vos démarches sont à jour";
  static String demarchesNotUpToDateMessage =
      "Une erreur technique s’est produite. Certaines de vos démarches ne sont peut-être pas à jour.";
  static String reloadPage = "Recharger la page";
  static String agendaUpToDate = "Vos rendez-vous et démarches sont à jour";
  static String agendaNotUpToDate =
      "Une erreur technique s’est produite. Certains de vos rendez-vous et démarches ne sont peut-être pas à jour.";

  static String dateDerniereMiseAJourRendezvous(String date) => "Dernière actualisation de vos rendez-vous le $date";

  static String dateDerniereMiseAJourDemarches(String date) => "Dernière actualisation de vos démarches le $date";

  // Diagoriente
  static String diagorienteEntryPageTitle = "Préférences métiers";
  static String diagorienteMetiersCardTitle = "Découvrez de nouveaux métiers";
  static String diagorienteMetiersCardSubtitle =
      "Explorez les métiers qui correspondent à vos centres d'intérêt en répondant à quelques questions.";
  static String diagorienteMetiersCardButton = "Commencer";
  static String diagorienteMetiersCardError =
      "Une erreur est survenue. Vérifiez votre connexion ou réessayez plus tard.";
  static String diagorienteChatBotPageTitle = "Découvrir des métiers";
  static String diagorienteMetiersFavorisPageTitle = "Mes métiers favoris";
  static String diagorienteDiscoverCardTitle = "Découvrez de nouveaux métiers et retrouvez vos métiers favoris !";
  static String diagorienteDiscoverCardSubtitle = "Explorez les métiers qui correspondent à vos centres d’intérêt.";
  static String diagorienteDiscoverCardPressedTip = "En savoir plus";
  static String diagorienteMetiersFavorisCardTitle = "Retrouvez vos métiers favoris";
  static String diagorienteMetiersFavorisCardSubtitle = "Mes métiers favoris";
  static String diagorienteMetiersFavorisCardPressedTip = "Voir";
  static String diagorienteVoirplus = "Voir plus";
  static String diagorienteAffinerMesResultats = "Affiner mes résultats";
  static String diagorienteTerminerEtRetournerAuProfil = "Terminer et retourner au profil";

  // CV
  static String cvCardTitle = "CV";
  static String cvCardSubtitle =
      "Facilitez vos prochaines candidatures en téléchargeant vos CV Pôle emploi directement sur votre téléphone.";
  static String cvCadCaption = "Télécharger";
  static String cvListPageTitle = "CV";
}
