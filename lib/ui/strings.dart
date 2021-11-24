class Strings {
  Strings._();

  // Common
  static String appName = "Pass Emploi";
  static String retry = "Réessayer";
  static String logoTextDescription = "Logo Pass Emploi";
  static String myActions = "Mes actions";
  static String rendezvousListPageTitle = "Rendez-vous";
  static String close = "Fermer";

  // Menu
  static String menuHome = "Accueil";
  static String menuActions = "Actions";
  static String menuChat = "Messages";
  static String menuRendezvous = "Rendez-vous";
  static String menuSolutions = "Solutions";

  // Chat
  static String yourMessage = "Votre message…";
  static String yourConseiller = "Votre conseiller";
  static String today = "Aujourd'hui";
  static String read = "Lu";
  static String sent = "Envoyé";

  static String chatWith(firstName) => "Discuter avec $firstName";

  static String simpleDayFormat(day) => "Le $day";

  // Force Update
  static String update = "Mise à jour";
  static String forceUpdateExplanation = "Votre application nécessite d\'être mise à jour pour son bon fonctionnement";

  // Home
  static String dashboardError = "Erreur lors de la récupérations de votre tableau de bord";
  static String reconnect = "Me reconnecter";
  static String dashboardWelcome = "Bienvenue sur votre tableau de bord";
  static String refresh = "Rafraîchir";
  static String seeAllActions = "Voir toutes les actions";
  static String noActionsYetContactConseiller =
      "Vous n’avez pas encore d’actions en cours.\nContactez votre conseiller pour les définir avec lui";
  static String noMoreActionsContactConseiller =
      "Bravo :) Vous n’avez plus d’actions en cours.\nContactez votre conseiller pour obtenir de nouvelles actions";
  static String upcomingRendezVous = "Mes rendez-vous à venir";
  static String noUpcomingRendezVous =
      "Vous n’avez pas de rendez-vous prévus.\nContactez votre conseiller pour prendre rendez-vous";

  static String hello(firstName) => "Bonjour $firstName";

  // Loader (Splash)
  static String welcomeOn = "Bienvenue sur";

  // Login
  static String performLogin = "Connectez-vous";
  static String mandatoryAccessCodeError = "Votre code d\'accès doit être renseigné";
  static String yourAccessCode = "Votre code d\'accès";
  static String loginError = "Erreur lors de la connexion";
  static String login = "Connexion";
  static String loginAction = "Se connecter";

  // Rendez-Vous
  static String myRendezVous = "Mon rendez-vous";
  static String rendezVousConseillerCommentLabel = "Commentaire de mon conseiller";
  static String cantMakeItNoBigDeal = "Un imprévu ? Ce n’est pas grave, mais…";
  static String shouldInformConseiller =
      "En cas d’imprévu, il est impératif de prévenir votre conseiller. Pour cela, n’hésitez pas à le contacter via la messagerie de Pass emploi";

  static String rendezVousModalityMessage(modality) => "Le rendez-vous se fera $modality";

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

  // Offres Emploi
  static String offresEmploiTitle = "Résultats offres d'emploi";

  //Solutions
  static String searchingPageTitle = "Recherche de solutions";
  static String keyWordsTitle = "Mots clés";
  static String keyWordsTextField = "Métier, compétence...";
  static String jobLocationTitle = "Lieu de travail";
  static String jobLocationHint = "Département";
  static String searchButton = "RECHERCHER";
  static String offerDetails = "Détails de l'offre";

  // Solutions Errors
  static String noContentError = "Aucune offre ne correspond à votre recherche";
  static String genericError = "Erreur lors de la recherche. Veuillez réessayer";
  static String loadMoreOffresError = "Erreur lors du chargement des offres";

  //Detailed job offer
  static String offerDetailsError = "Erreur lors de la récupération de l'offre";
  static String offerDetailsTitle = "Détail de l'offre";
  static String profileTitle = "Profil souhaité";
  static String experienceTitle = "Expériences";
  static String companyDescriptionTitle = "Détail de l'entreprise";
  static String companyAdaptedTitle = "Entreprise adaptée";
  static String companyAccessibilityTitle = "Entreprise handi-bienveillante";
  static String companyTitle = "Entreprise";
  static String skillsTitle = "Savoir et savoir faire";
  static String softSkillsTitle = "Savoir être professionnel";
  static String languageTitle = "Langue";
  static String educationTitle = "Formation";
  static String driverLicenceTitle = "Permis";
  static String subscribeButtonTitle = "Recevoir l'offre par mail";
  static String applyButtonTitle = "Je postule";

  static String offreDetailNumber(String offreId) => "Offre n°$offreId";

  static String offreDetailLastUpdate(String lastUpdate) => "Actualisée le $lastUpdate";
}
