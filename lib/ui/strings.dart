class Strings {

  Strings._();

  // Common
  static String appName = "Pass Emploi";
  static String retry = "Réessayer";
  static String logoTextDescription = "Logo Pass Emploi";
  static String myActions = "Mes actions";
  static String close = "Fermer";

  // Chat
  static String yourMessage = "Votre message…";
  static String yourConseiller = "Votre conseiller";
  static String today = "Aujourd'hui";
  static String chatWith(firstName) => "Discuter avec $firstName";
  static String simpleHourFormat(hour) => "à $hour";
  static String simpleDayFormat(day) => "Le $day";

  // Force Update
  static String update = "Mise à jour";
  static String forceUpdateExplanation = "Votre application nécessite d\'être mise à jour pour son bon fonctionnement.";

  // Home
  static String dashboardError = "Erreur lors de la récupérations de votre tableau de bord.";
  static String reconnect = "Me reconnecter";
  static String dashboardWelcome = "Bienvenue sur votre tableau de bord";
  static String refresh = "Rafraîchir";
  static String seeAllActions = "Voir toutes les actions";
  static String noActionsYetContactConseiller = "Vous n’avez pas encore d’actions en cours.\nContactez votre conseiller pour les définir avec lui.";
  static String noMoreActionsContactConseiller = "Bravo :) Vous n’avez plus d’actions en cours.\nContactez votre conseiller pour obtenir de nouvelles actions.";
  static String upcomingRendezVous = "Mes rendez-vous à venir";
  static String noUpcomingRendezVous = "Vous n’avez pas de rendez-vous prévus.\nContactez votre conseiller pour prendre rendez-vous.";
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
      "En cas d’imprévu, il est impératif de prévenir votre conseiller. Pour cela, n’hésitez pas à le contacter via la messagerie de Pass emploi.";

  static String rendezVousModalityMessage(modality) => "Le rendez-vous se fera $modality.";

  // User Action
  static String actionsError = "Erreur lors de la récupérations de vos actions.";
  static String currentActions = "Mes actions en cours";
  static String noCurrentActionsYet = "Vous n'avez pas encore d’actions en cours.";
  static String finishedActions = "Mes actions terminées";
  static String nofinishedActionsYet = "Vous n'avez pas encore terminé d’actions.";
  static String actionDone = "Terminée";
  static String aboutThisAction = "À propos de cette action";
  static String actionDetails = "Détail de l'action";
  static String updateStatus = "Changer le statut";
  static String refreshActionStatus = "Actualiser";
  static String actionToDo = "À réaliser";
}
