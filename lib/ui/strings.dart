import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/ui/immersion_contacts_strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class _PassEmploiStrings {
  static String appName = "pass emploi";
  static String logoDescription = "Pass emploi";
  static String shouldInformConseiller =
      "En cas d’imprévu, il est important de prévenir votre conseiller. Vous pouvez le contacter via la messagerie de l’application pass emploi.";
  static String suppressionAccountLabel = "Supprimer mon compte de l’application pass emploi";
  static String warningInformationParagraph1 =
      "En supprimant votre compte de l’application pass emploi, vous perdrez définitivement toutes les données présentes sur l’application :";
  static String warningInformationParagraph2 =
      "La suppression de votre compte sur l’application pass emploi n'entraîne pas la suppression de votre accompagnement.";
  static String accountDeletionSuccess = "Votre compte a bien été supprimé de l’application pass emploi";
  static String modeDemoExplicationPremierPoint3 = " l’application pass emploi utilisée par vos bénéficiaires.";
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
  static String logoDescription = "Contrat d'Engagement Jeune";
  static String shouldInformConseiller =
      "En cas d’imprévu, il est important de prévenir votre conseiller. Vous pouvez le contacter via la messagerie de l’application CEJ.";
  static String suppressionAccountLabel = "Supprimer mon compte de l’application CEJ";
  static String warningInformationParagraph1 =
      "En supprimant votre compte de l’application CEJ, vous perdrez définitivement toutes les données présentes sur l’application :";
  static String warningInformationParagraph2 =
      "La suppression de votre compte sur l’application CEJ n'entraîne pas la suppression de votre accompagnement.";
  static String accountDeletionSuccess = "Votre compte a bien été supprimé de l’application CEJ";
  static String modeDemoExplicationPremierPoint3 = " l’application CEJ utilisée par vos bénéficiaires.";
  static String legalNoticeUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_mentions_legales";
  static String privacyPolicyUrl =
      "https://travail-emploi.gouv.fr/application-contrat-dengagement-jeune-cej-traitement-des-donnees-personnelles";
  static String termsOfServiceUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_conditions_generales";
  static String accessibilityUrl = "https://doc.pass-emploi.beta.gouv.fr/legal/mobile_accessibilite_application";
}

class Strings {
  Strings._();

  // Common
  static String appName = Brand.isCej() ? _CejStrings.appName : _PassEmploiStrings.appName;
  static String error = "Une erreur s’est produite";
  static String retry = "Réessayer";
  static String logoDescription = Brand.isCej() ? _CejStrings.logoDescription : _PassEmploiStrings.logoDescription;
  static String close = "Fermer";
  static String yes = "Oui";
  static String no = "Non";
  static String or = "OU";
  static String ajouter = "Ajouter";
  static String cancelLabel = "Annuler";
  static String suppressionLabel = "Supprimer";
  static String cacher = "Cacher";
  static String refuserLabel = "Refuser";
  static String consulter = "Consulter";
  static String copie = "Copié";
  static String notConnected = "Vous êtes hors connexion";
  static const String mandatoryFields = "Les champs marqués d’une * sont obligatoires.";
  static const String allMandatoryFields = "Tous les champs sont obligatoires.";
  static String duplicate = "Dupliquer";
  static String clear = "Effacer le texte";

  static String stepCounter(int current, int total) => "Étape $current sur $total";
  static String selectDateTooltip = "Sélectionner une date";
  static String removeDateTooltip = "Supprimer la date";

  // Login mode
  static const String milo = "Mission Locale";
  static const String franceTravail = "France Travail";
  static const String accompagnementIntensif = "Accompagnement intensif";
  static const String accompagnementGlobal = "Accompagnement global";
  static const String equipEmploiRecrut = "Equip emploi recrut";

  // Menu
  static String menuAccueil = "Accueil";
  static String menuMonSuivi = "Mon suivi";
  static const String menuChat = "Messages";
  static String menuSolutions = "Offres";
  static String menuFavoris = "Favoris";
  static String menuRendezvous = "Rendez-vous";
  static String menuProfil = "Mon profil";
  static String menuEvenements = "Événements";

  // Chat
  static String yourMessage = "Votre message…";
  static String yourConseiller = "Votre conseiller";
  static String today = "Aujourd'hui";
  static String edited = "Modifié";
  static String read = "Lu";
  static String sent = "Envoyé";
  static String sending = "Envoi en cours";
  static String sendingFailed = "L'envoi a échoué";
  static String sendMessageTooltip = "Envoyer le message";
  static String sendAttachmentTooltip = "Envoyer une pièce jointe";
  static String chatError = "Erreur lors de la récupération de votre messagerie";
  static String newConseillerTitle = "Vous échangez avec votre nouveau conseiller.";
  static String newConseillerTemporaireTitle = "Vous échangez temporairement avec un nouveau conseiller.";
  static String newConseillerDescription = "Il a accès à l’historique de vos échanges.";
  static String unknownTypeTitle = "Le message est inaccessible";
  static String unknownTypeDescription = "Pour avoir l'accès au contenu, veuillez mettre à jour l'application.";
  static String voirOffre = "Voir l'offre";
  static String voirEvent = "Voir l'événement";

  static String chatWith(firstName) => "Discuter avec $firstName";

  static String simpleDayFormat(day) => "Le $day";
  static String open = "Ouvrir";
  static String fileNotAvailableError = "ERROR: 410";
  static String fileNotAvailableTitle = "Le fichier n'est plus disponible";
  static String chatEmpty = "Commencez une conversation avec votre conseiller";
  static String chatEmptySubtitle =
      "Obtenez les informations que vous recherchez en contactant directement votre conseiller";

  static String chatMessageBottomSheetTitle = "Paramètres du message";
  static String chatCopyMessage = "Copier";
  static String chatDeleteMessage = "Supprimer";
  static String chatEditMessage = "Modifier";

  static String chatExpiredPjMessage = "Pièce jointe expirée";
  static String chatDeletedMessage = "Message supprimé";
  static String chatEditMessageAppBar = "Modifier le message";
  static String editMessageSave = "Modifier";

  static String chatDeletedMessageContent = "(Message supprimé)";

  static String chatOpenPieceJointe = "Ouvrir la pièce jointe";
  static String chatPieceJointeBottomSheetTitle = "Ajouter une pièce jointe";
  static String chatPieceJointeBottomSheetSubtitle =
      "Attention à ne pas partager vos données personnelles ou d’informations sensibles notamment votre numéro de Sécurité Sociale (ex : Carte Vitale, etc.)";
  static String chatPieceJointeBottomSheetTakeImageButton = "Prendre une photo";
  static String chatPieceJointeBottomSheetSelectImageButton = "Sélectionner une photo";
  static String chatPieceJointeBottomSheetSelectFileButton = "Sélectionner un fichier";
  static String chatPieceJointeBottomSheetFileTooLarge =
      "Le fichier est trop volumineux. Veuillez sélectionner un fichier de moins de 5 Mo.";
  static String chatPieceJointeGalleryPermissionError =
      "Autorisez l’accès à la galerie pour pouvoir sélectionner une image.";
  static String chatPieceJointeCameraPermissionError =
      "Autorisez l’accès à l'appareil photo pour pouvoir prendre une photo.";
  static String chatPieceJointeFilePermissionError =
      "Autorisez l’accès aux fichiers pour pouvoir sélectionner un fichier.";
  static String chatPieceJointeOpenAppSettings = "Accéder aux paramètres";
  static String chatA11yMessageFromMe = "Mon message : ";
  static String chatA11yMessageFromMyConseiller = "Message de mon conseiller : ";
  static String chatA11yLastMessage = "Dernier message : ";

  // Force Update
  static String updateTitle = "Mise à jour";
  static String updateButton = "Mettre à jour";
  static String forceUpdateOnStoreLabel = "Votre application nécessite d'être mise à jour pour son bon fonctionnement";
  static String forceUpdateOnFirebaseLabel =
      "Votre application nécessite d'être mise à jour sur Firebase pour son bon fonctionnement";

  // First Launch Onboarding
  static String start = "Démarrer";

  static String firstLaunchOnboardingCardTitle1 = "Echangez à tout moment avec votre conseiller dédié";
  static String firstLaunchOnboardingCardTitle2 = Brand.isCej()
      ? "Créez et suivez vos actions dans le cadre des 15h d’activité"
      : "Créez et suivez vos démarches dans le cadre des 15h d’activité";
  static String firstLaunchOnboardingCardTitle3 =
      "Trouvez les offres et les événements en lien avec votre projet professionnel";

  // Entree
  static String welcome = "Bienvenue";
  static String welcomeMessage = "L’application dédiée à votre accompagnement";
  static String noAccount = "Pas de compte ?";
  static String askAccount = "Demander un compte";
  static String suiviParConseillerCej =
      "Dans le cadre de mon Contrat d'Engagement Jeune, je suis suivi par un conseiller :";
  static String suiviParConseillerPassEmploi = "Je suis suivi par un conseiller :";
  static String dontHaveAccount = "Vous n’avez pas de compte sur cette application ?";

  static String alreadyHaveAccount = "Vous avez déjà un compte\n sur cette application ?";
  static String accessibilityPartiallyConform = "Accessibilité : partiellement conforme";
  static String accessibilityNotConform = "Accessibilité : non conforme";

  // Onboarding
  static String skip = "Passer";
  static String continueLabel = "Continuer";
  static String letsGo = "C'est parti !";
  static String gotIt = "C'est compris";
  static String discover = "Découvrir";

  static String onboardingMonSuiviTitle = "Pas à pas, trouvez un emploi stable";
  static String onboardingChatTitle = "Gardez contact avec votre conseiller à tout moment";
  static String onboardingRechercheTitle = "Trouvez des offres qui vous intéressent";
  static String onboardingEvenementsTitle = "Participez à des événements en lien avec votre recherche";
  static String onboardingOffreEnregistreeTitle = "Nouveau\u{00A0}!";

  static String onboardingMonSuiviBodyCej =
      "Mon suivi vous permet de créer et visualiser les différentes actions ou rendez-vous à réaliser. Votre conseiller peut aussi ajouter des actions dans cette section !";
  static String onboardingMonSuiviBodyPe =
      "Mon suivi vous permet de créer et visualiser les différentes démarches ou rendez-vous à réaliser. Votre conseiller peut aussi ajouter des démarches dans cette section !";
  static String onboardingChatBody =
      "Échangez sur la messagerie instantanée avec votre conseiller pour construire votre projet, partager des offres, vous inscrire à des évènements, etc.";
  static String onboardingRechercheBodyCej =
      "L’espace recherche vous permet de retrouver les offres d’emploi d’alternance, d’immersion et de service civique, et de les ajouter à vos offres suivies.";
  static String onboardingRechercheBodyPe =
      "L’espace recherche vous permet de retrouver les offres d’emploi qui vous intéressent et de les ajouter à vos offres suivies.";
  static String onboardingEvenementsBody =
      "Découvrez les événements à ne pas manquer en lien avec votre recherche et inscrivez-vous pour y participer.";
  static String onboardingOffreEnregistreeBody = "Retrouvez maintenant vos favoris dans l’onglet “Suivi des offres”";

  static String takeRdvWithConseiller =
      "Prenez rendez-vous avec votre conseiller qui procédera à la création de votre compte.";
  static String whoIsConcerned = "Qui est éligible ?";
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

  static String installOnboardingSection = "Installez l’application";
  static String messageOnboardingSection = "Envoyez un message";
  static String actionOnboardingSection = "Créez une action";
  static String demarcheOnboardingSection = "Créez une démarche";
  static String offreOnboardingSection = "Recherchez une offre";
  static String evenementOnboardingSection = "Recherchez un événement";
  static String outilsOnboardingSection = "Consultez les outils";

  static String skipOnboarding = "Passer le tutoriel";
  static String skipOnboardingContent = "Êtes-vous sûr de vouloir passer le tutoriel ?";

  static String onboardingShowcaseMessageTitle = "Saluez votre conseiller.";
  static String onboardingShowcaseActionTitle = "Lancez-vous !";
  static String onboardingShowcaseOffreTitle = "Un emploi en tête?";
  static String onboardingShowcaseEvenementTitle = "Explorez les événements en lien avec votre projet pro";
  static String onboardingShowcaseOutilsTitle = "Besoin d’un coup de pouce?";
  static String onboardingShowcaseMessageDescription =
      "Envoyez lui un premier message “Bonjour ! j’ai bien téléchargé l’application, j’ai hâte de commencer !”";
  static String onboardingShowcaseActionDescription =
      "Créez une première action pour vous rapprocher de votre objectif ";
  static String onboardingShowcaseOffreDescription =
      "Lancez votre recherche pour découvrir des opportunités qui correspondent à vos critères";
  static String onboardingShowcaseEvenementDescription =
      "Participez à des salons, forums, ateliers pour faire avancer votre projet pro";
  static String onboardingShowcaseOutilsDescription = "Retrouvez les bons outils pour vous guider à chaque étapes";

  static String onboardingStepFinished = "🎉 Bravo vous avez validé une étape du tutoriel !";

  // Login bottom sheet
  static const String loginBottomSeetFranceTravailButton = "France travail";
  static const String loginBottomSeetMissionLocaleButton = "Mission Locale";
  static const String loginBottomSeetNoOrganism = "Je ne suis inscrit à aucun de ces organismes";

  static const String loginBottomSeetTitlePage1 = "Sélectionnez l’organisme dont dépend votre conseiller CEJ : ";
  static const String organismInformations =
      "L’organisme est celui avec lequel vous avez signé votre contrat CEJ. Cette information est visible sur votre contrat CEJ dans la case “Opérateur”.";

  static const String loginBottomSeetTitlePage2 = "Pour vous connecter, vous aurez besoin des éléments suivants : ";

  static List<String> loginInfosUserName(bool isPoleEmploi) =>
      isPoleEmploi ? loginBottomSheetEmailInfosPoleEmploi : loginBottomSheetEmailInfosCej;

  static List<String> loginBottomSheetPasswordInfos(bool isPoleEmploi) =>
      isPoleEmploi ? loginBottomSheetPasswordInfosPoleEmploi : loginBottomSheetPasswordInfosCej;

  static const List<String> loginBottomSheetEmailInfosCej = [
    "L’adresse mail",
    " que vous avez fourni à votre conseiller"
  ];
  static const List<String> loginBottomSheetPasswordInfosCej = [
    "Le mot de passe",
    " créé lors de la réception du mail d’activation"
  ];

  static const List<String> loginBottomSheetEmailInfosPoleEmploi = [
    "Le nom d’utilisateur",
    " créé lors de votre inscription à France Travail"
  ];
  static const List<String> loginBottomSheetPasswordInfosPoleEmploi = [
    "Le mot de passe",
    " de votre espace personnel France Travail"
  ];

  static String loginBottomSheetRecuperationInfos(bool isPoleEmploi) =>
      isPoleEmploi ? loginBottomSheetRecuperationInfosPoleEmploi : loginBottomSheetRecuperationInfosCej;

  static const String loginBottomSheetRecuperationInfosCej =
      "Si vous avez oublié votre mot de passe ou vous n’avez pas reçu le mail d’activation, vous pourrez le réinitialiser en cliquant sur Mot de passe oublié.";

  static const String loginBottomSheetRecuperationInfosPoleEmploi =
      "Si vous avez oublié votre nom d’utilisateur ou votre mot de passe, vous pourrez les récupérer à l’étape suivante.";

  static String loginOpenInNewDescription(bool isPoleEmploi) =>
      isPoleEmploi ? loginOpenInNewDescriptionPoleEmploi : loginOpenInNewDescriptionCej;

  static const String loginOpenInNewDescriptionCej =
      "Vous serez redirigé vers la page d'authentification de Mission Locale pour vous connecter.";

  static const String loginOpenInNewDescriptionPoleEmploi =
      "Vous serez redirigé vers la page d'authentification de France Travail pour vous connecter.";

  static const String loginNoAccount = "Pas de compte ?";

  // Login
  static String loginWrongDeviceClockError = "L'heure de votre téléphone semble erronée, impossible de vous connecter.";
  static String loginWrongDeviceClockErrorDescription =
      "Accédez aux réglages de votre téléphone pour vérifier que l’heure et le fuseau horaire affichés sont corrects.";
  static String loginGenericError = "Erreur lors de la connexion";
  static String loginGenericErrorDescription =
      "Réessayer plus tard. Si le problème persiste, vous pouvez contacter votre conseiller.";
  static String loginPoleEmploi = "France Travail";
  static String loginMissionLocale = "Mission Locale";
  static String loginAction = "Se connecter";
  static String logoutAction = "Se déconnecter";

  // Card and subcomponents
  static const String emploiTag = "Offre d’emploi";
  static const String alternanceTag = "Alternance";
  static const String immersionTag = "Immersion";
  static const String serviceCiviqueTag = "Service civique";

  static const String todoPillule = "À réaliser";
  static const String doingPillule = "En cours";
  static const String donePillule = "Terminée";
  static const String latePillule = "En retard";
  static const String canceledPillule = "Annulée";
  static const String newPillule = "Nouveau";

  // Onboarding
  static String onboardingTitle = "Terminez la découverte de l’application";

  // notifications bottom sheet
  static String notificationsBottomSheetTitle = "Activez les notifications pour ne rien manquer";
  static String notificationsBottomSheetcontent =
      "Messages importants, rappel des rendez-vous, actions à faire, nouvelles offres en fonction de vos critères… On vous prévient au bon moment.";
  static String notificationsBottomSheetButton = "Activer les notifications";

  // Accueil
  static String accueilAppBarTitle = "Bienvenue";
  static String onboardingAccueilTitle = "Découvrez l’application en quelques étapes";
  static String onboardingAccueilTitleCompleted = "🎉 Vous avez terminé le tutoriel !";
  static String accueilCetteSemaineSection = "Cette semaine";
  static String accueilVoirDetailsCetteSemaine = "Voir le détail de ma semaine";
  static String accueilRendezvousSection = "Votre prochain rendez-vous";
  static String accueilActionSingular = "Action";
  static String accueilActionPlural = "Actions";
  static String accueilError = "Erreur lors de la récupération de votre page d’accueil";
  static String accueilDemarcheSingular = "Démarche";
  static String accueilDemarchePlural = "Démarches";
  static String accueilRendezvous = "Rendez-vous";
  static String accueilEvenementsSection = "Événements pouvant vous intéresser";
  static String accueilVoirLesEvenements = "Voir plus d’événements";
  static String accueilMesAlertesSection = "Mes alertes";
  static String accueilVoirMesAlertes = "Voir toutes mes alertes";
  static String accueilPasDalerteDescription =
      "Créez des alertes lors de vos recherches et recevez les offres qui vous correspondent";
  static String accueilPasDalerteBouton = "Commencer une recherche";
  static String accueilOffresEnregistreesSection = "Mon suivi des offres";
  static String accueilOutilsSection = "Outils";
  static String accueilOutilsSectionDescription = "Découvrez des outils pour vous aider dans vos projets";
  static String accueilVoirLesOutils = "Voir tous les outils";
  static String accueilCampagneRecrutementLabelCej = "Aidez-nous à améliorer l’application du CEJ\u{00A0}!";
  static String accueilCampagneRecrutementLabelPassEmploi = "Aidez-nous à améliorer l’application pass emploi\u{00A0}!";
  static String accueilCampagneRecrutementLabel =
      Brand.isCej() ? accueilCampagneRecrutementLabelCej : accueilCampagneRecrutementLabelPassEmploi;
  static String accueilCampagneRecrutementPressedTip = "Participer";

  // Mon Suivi
  static String monSuiviTitle = "Mon suivi";
  static String monSuiviCetteSemaine = "Cette semaine";
  static String monSuiviSemaineProchaine = "Semaine prochaine";
  static String monSuiviEmptyPastMilo = "Aucun événement ni action";
  static String monSuiviEmptyPastPoleEmploi = "Aucun rendez-vous ni démarche";
  static String monSuiviEmptyFuture = "Rien de prévu";
  static String monSuiviError = "Erreur lors de la récupération de votre suivi";
  static String monSuiviSessionMiloError = "Des événements n’ont peut-être pas pu être récupérés.";
  static String monSuiviTooltip = "Aller à aujourd'hui";
  static String monSuiviPePastLimitReached = "Les démarches et les rendez-vous plus anciens ne sont pas disponibles";
  static String monSuiviPeFutureLimitReached = "Les démarches et les rendez-vous plus récents ne sont pas disponibles";
  static String monSuiviPoleEmploiDataError = "Certaines démarches et rendez-vous ne sont peut-être pas à jour.";
  static String monSuiviA11yPreviousPeriodButton = "Afficher la période précédente";
  static String monSuiviA11yNextPeriodButton = "Afficher la période suivante";

  // Actualisation PE
  static String actualisationPePopUpTitle = "La période d’actualisation France Travail a commencé";
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
      Brand.isCej() ? _CejStrings.shouldInformConseiller : _PassEmploiStrings.shouldInformConseiller;

  static String rendezVousDetailsError = "Erreur lors de la récupération de l'événement";
  static String conseillerIsPresent = "Votre conseiller sera présent";
  static String conseillerIsNotPresent = "Votre conseiller ne sera pas présent";
  static String commentWithoutConseiller = "Description";
  static String rendezVousDetails = "Détails";
  static String seeItinerary = 'Voir l\'itinéraire';
  static String seeVisio = 'Accéder à la visio';
  static String rendezvousVisioModalityMessage =
      'Le rendez-vous se fera en visio. La visio sera disponible le jour du rendez-vous.';
  static String withConseiller = " avec ";
  static String individualInterview = "Entretien individuel conseiller";
  static String publicInfo = "Information collective";
  static String shareToConseiller = "Partager à mon conseiller";
  static String shareToConseillerDemandeInscription = "Faire une demande d’inscription";
  static String autoInscriptionCta = "M'inscrire pour participer";
  static String withAnimateurTitle = "Animateur de la session";

  static String rendezvousWithConseiller(String conseiller) => "votre conseiller $conseiller";

  static String rendezvousCreateur(String createur) {
    return "Le rendez-vous a été programmé par votre conseiller précédent $createur";
  }

  static String rendezvousModalityDetailsMessage(String modality) => "Le rendez-vous se fera $modality";

  static String rendezvousModalityCardMessage(String modality, String conseiller) => "$modality avec $conseiller";
  static String placesRestantes(int count) => "$count ${count == 1 ? placesRestanteSingulier : placesRestantePluriel}";
  static String placesRestanteSingulier = "place restante";
  static String placesRestantePluriel = "places restantes";

  static String phone(String phone) => "Téléphone : $phone";

  // App evaluation
  static String evalTitle = "Votre expérience sur l’application";
  static String evalDescription = "Aidez-nous à améliorer l’application en répondant à quelques questions.";
  static String evalButton = "Donner son avis";

  static String nextButtonTitle = "Suivant";
  static String validateButtonTitle = "Valider";
  static String mandatory = "Les questions marquées d'une * sont obligatoires";
  static String pourquoiTitle = "Pourquoi ?";
  static String evaluationSuccessfullySent = "Vous avez répondu aux questions, merci\u{00A0}!";

  // User action form
  static const String createActionAppBarTitle = 'Créer une action';
  static const String userActionBackButton = 'Retour';
  static const String userActionNextButton = 'Continuer';
  static const String userActionFinishButton = 'Terminer';

  static const String userActionTitleStep1 = 'Catégorie';
  static const String userActionTitleStep2 = 'Mon action';
  static const String userActionTitleStep3 = 'Statut et date';

  static const String userActionSubtitleStep1 = 'Choisissez une catégorie';

  static const String userActionSubtitleStep2 = '*Pouvez-vous nous en dire plus ?';
  static const String userActionTitleTextfieldStep2 = '*Nommer mon action';
  static const String userActionDescriptionTextfieldStep2 = 'Décrire mon action';
  static const String userActionDescriptionDescriptionfieldStep2 =
      'Ajouter des détails pour que votre conseiller puisse valider votre action.';

  static const String userActionStatusRadioStep3 = 'L’action est :';
  static const String userActionRadioGroup = "L'action est";
  static const String userActionStatusRadioCompletedStep3 = 'Terminée';
  static const String userActionStatusRadioTodoStep3 = 'En cours';
  static const String datePickerTitle = 'Date';
  static const String datePickerTitleMandatory = '*Date';

  static const String dateSuggestionAujourdhui = 'Aujourd’hui';
  static const String dateSuggestionDemain = 'Demain';
  static const String dateSuggestionSemainePro = 'Semaine prochaine';
  static const String dateSuggestionHier = 'Hier';

  static const String userActionEmploiLabel = 'Emploi';
  static const String userActionProjetProfessionnelLabel = 'Projet pro';
  static const String userActionCultureSportLoisirsLabel = 'Sport et loisirs';
  static const String userActionCitoyenneteLabel = 'Citoyenneté';
  static const String userActionFormationLabel = 'Formation';
  static const String userActionLogementLabel = 'Logement';
  static const String userActionSanteLabel = 'Santé';

  static const String userActionEmploiDescription = 'Recherches, candidatures';
  static const String userActionProjetProfessionnelDescription = 'Définir un projet professionnel';
  static const String userActionCultureSportLoisirsDescription = 'Cours de sport, salle, sorties';
  static const String userActionCitoyenneteDescription = 'Démarches, passer le permis';
  static const String userActionFormationDescription = 'En présentiel ou en ligne';
  static const String userActionLogementDescription = 'Recherches de logement';
  static const String userActionSanteDescription = 'Rendez-vous médicaux';

  static const String userActionConfirmationTitle = "Action créée";
  static const String userActionConfirmationSubtitle =
      "L’action est en route vers votre conseiller. Vous pourrez en discuter ensemble lors de votre prochain rendez-vous\u{00A0}!";

  static const String userActionConfirmationSeeDetailButton = "Consulter mon action";
  static const String userActionConfirmationCreateMoreButton = "Créer une autre action";

  static const String userActionDescriptionConfirmationTitle = "Cette action ne contient aucune description.";
  static const String userActionDescriptionConfirmationSubtitle =
      "Votre conseiller risque de ne pas pouvoir valider cette action.";
  static const String userActionDescriptionConfirmationConfirmButton = "Ajouter une description";
  static const String userActionDescriptionConfirmationGoToDescriptionButton = "Créer l’action sans description";
  static const String userActionDescriptionConfirmationTerminer = "Terminer l'action sans description";
  static String fieldMaxLengthExceeded(int maxLength) => "La limite de $maxLength caractères a été atteinte";

  // Emploi
  static const String faireMonCV = "Faire mon CV";
  static const String hintFaireMonCV = "J'ai mis à jour mon CV avec mon dernier stage, etc.";

  static const String rechercheEmploi = "Recherche d'emploi";
  static const String hintRechercheEmploi =
      "J'ai cherché des offres sur l'application Mes Offres, j'ai identifié 3 offres dans le secteur de l'automobile, etc.";

  static const String candidature = "Candidature";
  static const String hintCandidature = "J'ai déposé mon CV à la boulangerie rue de Sèvres, etc.";

  static const String entretienEmbauche = "Entretien d'embauche";
  static const String hintEntretienEmbauche =
      "J'ai eu un entretien avec le responsable du magasin d'informatique, etc.";

  static const String lettreMotivationEmploi = "Lettre de motivation";
  static const String hintLettreMotivationEmploi =
      "J'ai rédigé ma lettre de motivation pour postuler à un poste de serveur à Saint Raphaël, etc.";

  static const String rechercheStageEmploi = "Recherche de stage";
  static const String hintRechercheStageEmploi =
      "J'ai cherché des stages sur 1jeune1solution, j'ai identifié 2 offres dans le secteur du tourisme, etc.";

  // Projet Professionnel
  static const String rechercheStageProjetPro = "Recherche de stage";
  static const String hintRechercheStageProjetPro =
      "J'ai cherché des stages sur 1jeune1solution, j'ai identifié 2 offres dans le secteur du tourisme, etc.";

  static const String formationProjetPro = "Formation";
  static const String hintFormationProjetPro =
      "J'ai fait une formation en ligne sur les nouveaux outils marketing, etc.";

  static const String revisions = "Révisions";
  static const String hintRevisions = "J'ai révisé mes motivations pour mon oral de la semaine prochaine, etc.";

  static const String rechercheAlternance = "Recherche d'alternance";
  static const String hintRechercheAlternance =
      "J'ai cherché des alternances sur La Bonne Alternance, j'ai identifié 2 offres dans le secteur du tourisme, etc.";

  static const String enqueteMetier = "Enquête métier";
  static const String hintEnqueteMetier =
      "J'ai été poser des questions aux vendeurs des magasins de sport à côté de chez moi, etc.";

  static const String lettreMotivationProjetPro = "Lettre de motivation";
  static const String hintLettreMotivationProjetPro =
      "J'ai mis à jour ma lettre de motivation pour postuler à des emplois saisonniers, etc.";

  // Citoyenneté
  static const String examenPermis = "Examen permis, code";
  static const String hintExamenPermis = "J'ai passé mon permis, j'ai passé mon code, etc.";

  static const String codeRoute = "Code de la route";
  static const String hintCodeRoute = "J'ai été à une séance de code, etc.";

  static const String conduite = "Conduite";
  static const String hintConduite = "J'ai fait une séance de conduite en ville, etc.";

  static const String demarchesAdministratives = "Démarches administratives";
  static const String hintDemarchesAdministratives =
      "J'ai été à la mairie récupérer mon passeport, j'ai rempli les documents demandés par la CAF, etc.";

  static const String demandeAllocations = "Demande d'allocations";
  static const String hintDemandeAllocations =
      "J'ai déposé mon dossier pour MobiliJeune, j'ai récupéré les documents pour ma demande d'APL, etc.";

  static const String benevolat = "Bénévolat";
  static const String hintBenevolat = "J'ai fait 2h de bénévolat à la SPA, etc.";

  // Santé
  static const String rendezVousMedical = "Rendez-vous médical";
  static const String hintRendezVousMedical = "J'ai été à un rendez-vous médical, etc.";

  static const String bilanSante = "Bilan de santé";
  static const String hintBilanSante = "J'ai effectué un bilan au centre de santé CPAM, etc.";

  static const String carteVitale = "Carte vitale";
  static const String hintCarteVitale = "J'ai fait les démarches pour faire renouveler ma carte vitale, etc.";

  static const String demarchesSante = "Démarches de santé";
  static const String hintDemarchesSante = "J'ai déposé ma demande de dossier RQTH, etc.";

  static const String hospitalisation = "Hospitalisation";
  static const String hintHospitalisation = "J'ai été hospitalisé pendant 3 jours, etc.";

  static const String reeducation = "Rééducation";
  static const String hintReeducation = "J'ai été à ma séance de kiné, etc.";

  // Logement
  static const String rechercheLogement = "Recherche de logement";
  static const String hintRechercheLogement =
      "J'ai cherché un appartement à Pantin sur SeLoger, j'ai regardé les offres de logement sociaux dans ma commune, etc.";

  static const String constitutionDossier = "Constitution d'un dossier";
  static const String hintConstitutionDossier = "J'ai rédigé avec mes parents une attestation d'hébergement, etc.";

  static const String visiteLogement = "Visite de logement";
  static const String hintVisiteLogement = "J'ai visité l'appartement rue de Lille, etc.";

  static const String achatImmobilier = "Achat immobilier";
  static const String hintAchatImmobilier = "J'ai été chez le courtier pour faire évaluer ma capacité d'emprunt, etc.";

  static const String demandeAideLogement = "Demande d'aide logement";
  static const String hintDemandeAideLogement = "J'ai récupéré les documents pour ma demande d'APL, etc.";

  // Formation
  static const String rechercheFormation = "Recherche de formation";
  static const String hintRechercheFormation = "J'ai fait des recherches sur les BTS en diététique à Amiens, etc.";

  static const String rechercheApprentissage = "Recherche d'apprentissage";
  static const String hintRechercheApprentissage =
      "J'ai identifié des offres d'apprentissage en boulangerie sur le site l'Apprenti, etc.";

  static const String atelier = "Atelier";
  static const String hintAtelier = "J'ai participé à l'atelier CV, etc.";

  static const String rechercheSubvention = "Recherche de subvention";
  static const String hintRechercheSubvention =
      "J'ai identifié les subventions de la région pour ma formation d'artisan, etc.";

  // Loisirs, Sport, Culture
  static const String sport = "Sport";
  static const String hintSport = "J'ai fait 2h de football avec mon club, etc.";

  static const String cinema = "Cinéma";
  static const String hintCinema = "J'ai été voir \"Horizon\" au cinéma, etc.";

  static const String expositionMusee = "Exposition, musée";
  static const String hintExpositionMusee = "J'ai été voir les expositions du \"Voyage à Nantes\", etc.";

  static const String spectacleConcert = "Spectacle, concert";
  static const String hintSpectacleConcert = "J'ai été voir la comédie musicale \"le Roi Lion\" au théâtre, etc.";

  static const String dessinMusiqueLecture = "Dessin, musique, lecture";
  static const String hintDessinMusiqueLecture =
      "J'ai été à mon cours de piano, j'ai lu le roman l'Alchimiste de Paulo Coelho, etc.";

  // Autre
  static const String userActionOther = "Autre";
  static const String hintUserActionOther = "Je précise l'activité réalisée, son objectif, etc.";

  // User Action
  static const String exampleHint = "Exemple : ";
  static String aboutThisAction = "À propos de cette action";
  static String actionDetails = "Mon action";
  static String demarcheDetails = "Détail de la démarche";
  static String completeAction = "Terminer mon action";
  static String unCompleteAction = "Je n’ai pas terminé mon action";
  static String userActionDetailsSection = "Détails";
  static String userActionDate = "Date";
  static String userActionCategory = "Catégorie";
  static String userActionNoCategory = "Aucune";
  static String updateStatus = "Modifier le statut";
  static String refreshActionStatus = "Valider le statut";
  static String addAnAction = "Créer une action";
  static String addAMessageError = "Vous avez dépassé le nombre de caractères autorisés";
  static String create = "Créer";
  static String actionLabel = "*Intitulé de l'action";
  static String actionDescription = "Description de l'action";
  static String mandatoryActionLabelError = "L'intitulé de l'action doit être renseigné";
  static String mandatoryDateEcheanceError = "La date d'échéance doit être renseignée";
  static String defineActionStatus = "Définir le statut";
  static String actionCreatedBy = "Créée par";

  static String actionCreationInfos(String creator, String date) => "Ajouté par $creator le $date";
  static String youLowercase = "vous";
  static String you = "Vous";
  static String yourConseillerLowercase = "votre conseiller";
  static String congratulationsActionUpdated =
      "Félicitations !\n\nLa mise à jour de votre action a bien été prise en compte";
  static String understood = "J'ai compris";
  static String deleteActionError = "Erreur lors de la suppression de l'action. Veuillez réessayer";
  static String deleteActionSuccess = "L’action a bien été supprimée";
  static String createActionSuccess = "Votre action a bien été créée.";
  static String createActionPostponed =
      " Votre action a bien été créée. Le détail sera disponible au rétablissement du réseau.";
  static String createDemarcheSuccess = "La démarche a bien été créée";
  static String linkDetailsRendezVous = "Voir les détails du rendez-vous";

  static String dateEcheanceFormat(String formattedDate) => "À réaliser pour le $formattedDate";
  static String doneActionsTitle = "Actions terminées et annulées";
  static String rappelSwitch = 'Recevoir une notification de rappel 3 jours avant l’échéance';

  static String numberOfActions(int count) => "$count actions";

  static String numberOfDemarches(int count) => "$count démarches";
  static String see = "Voir";
  static String pendingActionCreationSingular = "1 action est en attente de réseau.";

  static String pendingActionCreationPlural(int count) => "$count actions sont en attente de réseau.";

  static String userActionDetailsError = "Erreur lors de la récupération de l'action";

  // User action bottom sheet
  static String userActionBottomSheetTitle = "Éditer l’action";
  static String userActionBottomSheetDelete = "Supprimer";
  static String userActionBottomSheetEdit = "Modifier";

  // User action done bottom sheet
  static String userActionDoneBottomSheetTitle = "Quand avez-vous terminé l'action ?";
  static String updateActionConfirmation = "La mise à jour de votre action a bien été prise en compte";

  // Update user action
  static String updateUserActionPageTitle = "Modifier l'action";
  static String updateUserAction = "Modifier l'action";
  static String updateUserActionTitle = "*Titre de l'action";
  static String updateUserActionDescriptionTitle = "Décrire mon action";
  static String updateUserActionDescriptionSubtitle = "Des précisions à partager à votre conseiller ?";
  static String updateUserActionCategory = "Catégorie";
  static String updateUserActionCategoryPressedTip = "Modifier";
  static String updateUserActionSaveButton = "Enregistrer les modifications";
  static String updateUserActionConfirmation = "Vos modifications ont été enregistrées.";
  static String deleteAction = "Supprimer l'action";
  static String deleteActionDescription = "Vous ne pourrez plus consulter ni modifier l'action.";

  // Duplicate user action
  static String duplicateUserAction = "Dupliquer l'action";
  static String duplicateUserActionConfirmationTitle = "Action dupliquée";

  // Commentaires d'action
  static String actionCommentsTitle = "Commentaire de l’action";
  static String lastComment = "Dernier commentaire";
  static String noComments = "Vous n’avez pas encore de commentaire";

  static String createdByAdvisor(String advisor) => "Votre conseiller $advisor";
  static String addComment = "Ajouter un commentaire";

  static String seeNComments(String n) => "Voir les $n commentaires";
  static String commentsUnavailableOffline = "Les commentaires de l'action ne sont pas disponibles hors connexion.";

  // Demarches
  static String demarcheDoneButton = "Terminer ma démarche";
  static String modifierStatut = "Modifier le statut";
  static String historiqueDemarche = "Historique";
  static String modifiedBy = "Modifiée le ";
  static String createdBy = "Créée le ";
  static String par = " par ";
  static String votreConseiller = "votre conseiller";
  static const String late = "En retard : ";
  static const String createDemarcheAppBarTitle = "Créer une démarche";
  static const String commentaire = "Commentaire";
  static const String descriptionDemarche = "Décrire la démarche";
  static const String caracteres255 = "255 caractères maximum";
  static const String quand = "Quand";
  static const String selectEcheance = "Sélectionner une date d'échéance";
  static const String addADemarche = "Créer une démarche";
  static const String createDemarcheTitle = "Création d'une démarche";
  static const String createDemarcheStep2EmptyTitle = "Aucune démarche ne correspond à votre recherche";

  static String createDemarcheStep2EmptyTitleWithQuery(String query) =>
      "Aucune démarche ne correspond à votre recherche “$query”";
  static const String createDemarcheStep2EmptySubtitle = "Essayez de reformuler ou lancez une nouvelle recherche";
  static const String noDemarcheFound = "Aucune démarche pre-renseignée n’a été trouvée";
  static const String selectDemarcheOrCreatePersonnalisee =
      "Sélectionnez une démarche ou créez une démarche personnalisée";
  static const String createDemarchePersonnaliseeTitle = "Créer une démarche personnalisée";
  static const String descriptionDemarchePersonnaliseeLabel = "Description de la démarche (obligatoire)";
  static const String selectDemarche = "Sélectionnez la démarche";
  static const String selectMoyen = "Sélectionnez le moyen";
  static const String addALaDemarche = "Créer la démarche";
  static const String validateLaDemarche = "Valider ma démarche";
  static const String searchDemarcheHint = "Renseigner un mot clé pour rechercher une démarche à créer";
  static const String searchDemarcheButton = "Rechercher une démarche";
  static const String mandatoryField = "Le champ est obligatoire";
  static const String comment = "Comment";
  static const String selectComment = "Sélectionner un des moyens";
  static const String selectQuand = "Sélectionner une date d’échéance";

  static String demarcheActiveLabel = "À réaliser pour le ";

  static String demarcheActiveDateFormat(String formattedDate) => demarcheActiveLabel + formattedDate;

  static String demarcheDoneLabel = "Réalisé le ";

  static String demarcheDoneDateFormat(String formattedDate) => demarcheDoneLabel + formattedDate;

  static String demarcheCancelledLabel = "Annulée le ";

  static String demarcheCancelledDateFormat(String formattedDate) => demarcheCancelledLabel + formattedDate;

  static String updateStatusError = "Erreur lors de la modification de l'action. Veuillez réessayer";

  static String withoutDate = "Date indéterminée";
  static String withoutContent = "Démarche indéterminée";
  static String createByAdvisor = "Créé par votre conseiller";
  static String demarcheRechercheSubtitle = "Rechercher par mot-clé";
  static String demarcheCategoriesSubtitle = "Rechercher par catégories";
  static String customDemarcheTitle = "Vous ne trouvez pas ce que vous cherchez ?";
  static String customDemarcheSubtitle = "Créez une démarche personnalisée qui correspond à votre situation.";

  static String demarcheBottomSheetTitle = "Éditer la démarche";

  static String demarcheSuccessTitle = "Démarche enregistrée";
  static String demarcheSuccessSubtitle =
      "La démarche est en route vers votre conseiller. Vous pourrez en discuter ensemble lors de votre prochain rendez-vous ! ";
  static String demarcheSuccessConsulter = "Consulter ma démarche";
  static String demarcheSuccessCreerUneAutre = "Créer une autre démarche";
  static String createDemarcheErreur = "Erreur lors de la création de la démarche. Veuillez réessayer plus tard";

  static String demarcheDoneBottomSheetTitle = "Quand avez-vous terminé la démarche ?";

  static String jeValide = "Je valide";
  static String felicitations = "Félicitations !";
  static String updateDemarcheConfirmation = "La mise à jour de votre démarche a bien été prise en compte";
  static String cancelDemarche = "Annuler la demarche";

  // Duplicate demarche
  static String duplicateDemarchePageTitle = "Dupliquer la démarche";
  static String duplicateDemarche = "Dupliquer la démarche";

  // Thematique de demarche
  static String demarcheThematiqueTitle = "Thématiques";
  static String demarchesCategoriesPressedTip = "Découvrir la liste";
  static String demarchesCategoriesDescription =
      "Recherchez parmi les thématiques d’emploi : candidatures, entretiens, création d’entreprise…";
  static String thematiquesDemarcheDescription = "Choisissez une thématique parmi les thématiques suivantes :";
  static String thematiquesDemarcheDescriptionShort = "Choisissez une thématique";
  static String dateShortMandatory = "Choisissez une date (obligatoire)";
  static String thematiquesDemarcheDateShort = "Choisissez une date";
  static String thematiquesDemarchePressedTip = "Parcourir les démarches";
  static String thematiquesErrorTitle = "Il y a un problème de notre côté\u{00A0}!";
  static String thematiquesErrorSubtitle =
      "Nous sommes en train de régler le problème. Réessayez plus tard ou créez une démarche personnalisée.";

  // Top démarche
  static String topDemarchesTitle = "Top démarches";
  static String topDemarchesSubtitle = "Inspirez-vous des démarches les plus utilisées";
  static String topDemarchesPressedTip = "Découvrir la liste";

  // Recherche
  static String derniereRecherche = "Dernière recherche";
  static String dernieresRecherches = "Dernières recherches";
  static String vosPreferencesMetiers = "Vos préférences métiers";
  static String rechercheHomeNosOffres = "Nos offres";
  static String rechercheDerniereOffreConsultee = "Dernière offre consultée";
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
  static String rechercheAfficherPlus = "Afficher plus d'offres";
  static String recherchePlaceholderTitle = "Effectuez votre recherche pour afficher des résultats";
  static String rechercheLancerUneRechercheHint = "Lancez une recherche pour afficher les offres vous correspondant";

  static String rechercheCriteresActifsZero = "0 critère actif";
  static String rechercheCriteresActifsOne = "(1) critère actif";

  static String rechercheCriteresActifsTooltip(bool isOpen) => "Formulaire de recherche ${isOpen ? 'ouvert' : 'fermé'}";

  static String rechercheCriteresActifsPlural(int count) => "($count) critères actifs";

  // Solutions
  static String keywordTitle = "Mot clé";
  static String keywordEmploiHint = "Saisissez un métier, une compétence, un secteur d'activité…";
  static String metierLabel = "Métier";
  static String metierImmersionHint = "Renseignez le métier pour lequel vous souhaitez faire une immersion.";
  static String locationTitle = "Localisation";
  static String locationMandatoryTitle = "*Localisation";
  static String jobLocationEmploiHint = "Sélectionnez une ville ou un département dans lequel vous cherchez un emploi.";
  static String jobLocationAlternanceHint =
      "Sélectionnez une ville ou un département dans lequel vous cherchez une alternance.";
  static String jobLocationImmersionHint = "Sélectionnez une ville dans laquelle vous cherchez une immersion.";
  static String jobLocationServiceCiviqueHint =
      "Sélectionnez une ville dans laquelle vous cherchez un service civique.";
  static String jobEvenementEmploiHint = "Sélectionnez une ville dans laquelle vous cherchez un événement.";
  static String searchButton = "Rechercher";
  static String offreDetails = "Détails de l'offre";
  static String rechercheTabTitle = "Recherche";
  static String offresEnregistreesTabTitle = "Suivi des offres";
  static String boiteAOutilsTabTitle = "Outils";
  static String solutionsAppBarTitle = "Offres";
  static String partagerOffreConseiller = "Partager l’offre à mon conseiller";
  static String partageOffreNavTitle = "Partage de l’offre d’emploi";
  static String souhaitDePartagerOffre = "L’offre que vous souhaitez partager";
  static String partageOffreDefaultMessage = "Bonjour, je vous partage une offre d’emploi afin d’avoir votre avis";
  static String partageOffreSuccess =
      "L’offre d’emploi a été partagée à votre conseiller sur la messagerie de l’application";
  static String messagePourConseiller = "Message destiné à votre conseiller";
  static String infoOffrePartageChat = "L’offre d’emploi sera partagée à votre conseiller dans la messagerie";
  static String partagerOffreEmploi = "Partager l’offre d’emploi";
  static String a11YLocationSuppressionLabel = "Supprimer la localisation";
  static String a11YKeywordSuppressionLabel = "Supprimer le mot clé";
  static String a11YMetierSuppressionLabel = "Supprimer le métier";
  static String a11YLocationWithDepartmentsExplanationLabel =
      "Commencez à saisir un nom de ville ou de département. Une liste de choix s'affiche directement sous le champ et se met à jour au fur et à mesure. Puis sélectionnez une ville ou un département dans lequel vous cherchez un emploi";
  static String a11YLocationWithoutDepartmentExplanationLabel =
      "Commencez à saisir un nom de ville. Une liste de choix s'affiche directement sous le champ et se met à jour au fur et à mesure. Puis sélectionnez une ville dans laquelle vous cherchez un emploi";
  static String a11YKeywordExplanationLabel =
      "Saisissez un mot clé correspondant à votre recherche d'emploi. Puis validez votre choix.";
  static String a11YMetiersExplanationLabel =
      "Commencez à saisir un métier. Une liste de choix s'affiche directement sous le champ et se met à jour au fur et à mesure. Puis sélectionnez un métier dans lequel vous cherchez une immersion";

  static String a11yPartagerOffreLabel = "Partager l’offre";
  static String a11yPartagerEvenementLabel = "Partager l’événement";

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

  // Evenement partage
  static String partageEvenementEmploiNavTitle = "Partage de l’événement";
  static String souhaitDePartagerEvenementEmploi = "L’événement que vous souhaitez partager";
  static String partageEvenementEmploiDefaultMessage = "Bonjour, je vous partage un événement afin d’avoir votre avis";
  static String partageEvenementEmploiSuccess =
      "L’événement a été partagé à votre conseiller sur la messagerie de l’application";
  static String infoEvenementEmploiPartageChat = "L’événement sera partagé à votre conseiller dans la messagerie";
  static String partagerEvenementEmploiAuConseiller = "Partager l’événement";

  // Session milo partage
  static String partageSessionMiloNavTitle = "Partage d’événement";
  static String souhaitDePartagerSessionMilo = "Ce que vous souhaitez partager";
  static String partageSessionMiloDefaultMessage = "Bonjour, pouvez-vous m'inscrire à cet événement ?";
  static String partageSessionMiloCompletMessage = "Bonjour, cet événement est complet mais je suis intéressé";
  static String partageSessionMiloSuccess =
      "L’événement a été partagé à votre conseiller sur la messagerie de l’application";
  static String infoSessionMiloPartageChat = "L’événement sera partagé à votre conseiller dans la messagerie";
  static String partagerSessionMiloAuConseiller = "Partager à mon conseiller";

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
  static String contactImmersionAlreadyDone =
      "Vous avez déjà postulé à cette offre d'immersion, il faut un minimum de 7 jours pour pouvoir postuler à nouveau";
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

  static String startDateEnabled(bool enabled) => enabled
      ? "Désactiver l'affichage des offres à partir d'une date"
      : "Activer l'affichage des offres à partir d'une date";
  static String domainFiltreTitle = "Domaine";
  static String asSoonAs = "Dès le ";
  static String serviceCiviqueDetailTitle = "Détails de l’offre de service civique";
  static String serviceCiviqueMissionTitle = "Mission";
  static String serviceCiviqueOrganisationTitle = "Organisation";

  // Solutions Errors
  static String noContentErrorTitle = "Pour le moment, aucune offre ne correspond à vos critères.";
  static String noContentErrorSubtitle =
      "Essayez d’élargir votre recherche en modifiant vos critères ou créez une alerte.";
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

  static String experienceSectionEnabled(bool enabled) => enabled
      ? "Désactiver l'affichage des offres débutants acceptés uniquement"
      : "Activer l'affichage des offres débutants acceptés uniquement";
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

  static String offreLastSeen(DateTime date) => "Vue ${date.timeAgo()}";
  static String offrePostulatedSeen(DateTime date) => "Postulé ${date.timeAgo()}";

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
      "Vous pouvez décider de la supprimer ou bien de la conserver dans vos offres suivies.";
  static String deleteOffreFromFavori = "Supprimer des offres suivies";
  static String interim = "Intérim";

  static String origin(String label) => "Source : $label";

  // Favoris
  static String mesFavorisPageTitle = "Mon suivis des offres";
  static String mesAlertesPageTitle = "Mes alertes";
  static String miscellaneousErrorRetry = "Une erreur est survenue. Veuillez réessayer";

  static String offreNumberAndLastUpdate(String offreId, String lastUpdate) =>
      "Offre n°$offreId, actualisée $lastUpdate";
  static String offreDetailNumber(String offreId) => "Offre n°$offreId";
  static String offreDetailLastUpdate(String lastUpdate) => "Actualisée $lastUpdate";

  static String offresEnregistreesEmptyTitle = "Suivez vos offres d’emploi ici";

  static String offresEnregistreesEmptySubtitle =
      "Retrouvez ici les offres qui vous intéressent et celles où vous avez postulé.";
  static String offresEnregistreesEmptyButton = "Lancer une recherche";
  static String offresEnregistreesError = "Erreur lors de la récupération de vos offres suivies";
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

  static String poleEmploiUrlButton = "Accéder à mon espace France Travail";
  static String espacePoleEmploiUrl = "https://candidat.pole-emploi.fr/espacepersonnel/";

  static String emptyContentTitle(String content) => "Vous n’avez pas encore de $content";

  static String emptyContentSubtitle(String content) => "Commencez en créant une nouvelle $content\u{00A0}!";

  static String emptyContentDescription(String content) =>
      "Vous pouvez créer vos $content en autonomie depuis votre espace France Travail.";

  // Profil
  static String personalInformation = "Informations personnelles";
  static String profilButtonSemanticsLabel = "Voir mon Profil";

  static String sinceDate(String date) => "Depuis le $date";
  static String emailAddressLabel = "Adresse e-mail";
  static String missingEmailAddressValue = "Non renseignée";
  static String legalInformation = "Informations légales";
  static String legalNoticeLabel = "Mentions légales";
  static String privacyPolicyLabel = "Politique de confidentialité";
  static String accessibilityLevelLabel = "Niveau d’accessibilité";
  static String accessibilityLevelNonConforme = "Non conforme";
  static String termsOfServiceLabel = "Conditions d'utilisation";

  static String legalNoticeUrl = Brand.isCej() ? _CejStrings.legalNoticeUrl : _PassEmploiStrings.legalNoticeUrl;
  static String privacyPolicyUrl = Brand.isCej() ? _CejStrings.privacyPolicyUrl : _PassEmploiStrings.privacyPolicyUrl;
  static String termsOfServiceUrl =
      Brand.isCej() ? _CejStrings.termsOfServiceUrl : _PassEmploiStrings.termsOfServiceUrl;
  static String accessibilityUrl = Brand.isCej() ? _CejStrings.accessibilityUrl : _PassEmploiStrings.accessibilityUrl;

  // Profil: Settings & account suppression
  static String settingsLabel = "Paramètres application";
  static String suppressionPageTitle = "Suppression de compte";
  static String suppressionAccountLabel =
      Brand.isCej() ? _CejStrings.suppressionAccountLabel : _PassEmploiStrings.suppressionAccountLabel;
  static String activityShareLabel = "Partage de votre activité";
  static String notificationsLabel = "Gérer vos notifications";

  static String partageFavorisEnabled(bool enabled) =>
      enabled ? "Désactiver le partage de mes offres suivies" : "Activer le partage de mes offres suivies";
  static String activityShareDescription =
      "Autorisez le partage pour permettre au conseiller d’avoir un suivi de votre activité.";
  static String warning = "Attention";
  static String suppressionButtonLabel = "Supprimer mon compte";
  static String warningInformationParagraph1 =
      Brand.isCej() ? _CejStrings.warningInformationParagraph1 : _PassEmploiStrings.warningInformationParagraph1;
  static String warningInformationParagraph2 =
      Brand.isCej() ? _CejStrings.warningInformationParagraph2 : _PassEmploiStrings.warningInformationParagraph2;
  static String warningInformationPoleEmploi =
      "Vos démarches et rendez-vous seront toujours disponibles dans votre portail France Travail.";
  static List<String> warningPointsMilo = [
    "vos actions",
    "vos messages avec votre conseiller",
    "vos rendez-vous",
    "vos recherches et offres sauvegardées"
  ];

  static List<String> warningPointsPoleEmploi = [
    "vos messages avec votre conseiller",
    "vos recherches et offres sauvegardées"
  ];
  static String lastWarningBeforeSuppression = "Tapez “supprimer” pour confirmer la suppression de votre compte.";
  static String mandatorySuppressionLabelError = "Champs invalide. Vérifiez que vous avez bien tapé “supprimer”";
  static String accountDeletionSuccess =
      Brand.isCej() ? _CejStrings.accountDeletionSuccess : _PassEmploiStrings.accountDeletionSuccess;

  static String shareFavoriteLabel = "Partager mes offres suivies";

  static String helpTitle = "Besoin d’aide ?";
  static String ratingAppLabel = "Partager votre avis sur l'application";
  static String contactTeamLabel = "Contacter l'équipe de l'application";

  // Notifications settings
  static const String notificationsSettingsAppbarTitle = "Gérer vos notifications";
  static const String notificationsSettingsSubtitle = "Recevoir des notifications pour les événements suivants :";

  static const String notificationsSettingsAlertesTitle = "Alertes";
  static const String notificationsSettingsAlertesSubtitle =
      "De nouvelles offres correspondant à vos alertes enregistrées";

  static const String notificationsSettingsMonSuiviTitle = "Mon suivi";

  static String notificationsSettingsMonSuiviSubtitle(bool isMilo) =>
      isMilo ? notificationsSettingsMonSuiviSubtitleMilo : notificationsSettingsMonSuiviSubtitleFT;

  static const String notificationsSettingsMonSuiviSubtitleMilo = "Création d’une action par votre conseiller";
  static const String notificationsSettingsMonSuiviSubtitleFT = "Création d’une démarche par votre conseiller";

  static String notificationsSettingsRendezVoussTitle(bool isMilo) =>
      isMilo ? notificationsSettingsRendezVoussTitleMilo : notificationsSettingsRendezVoussTitleFT;

  static const String notificationsSettingsRendezVoussTitleMilo = "Rendez-vous et sessions";
  static const String notificationsSettingsRendezVoussTitleFT = "Rendez-vous";
  static const String notificationsSettingsRendezVousSubtitle =
      "Inscription, modification ou suppression par votre conseiller";

  static const String notificationsSettingsRappelsTitle = "Rappels";

  static String notificationsSettingsRappelsSubtitle(bool isMilo) =>
      isMilo ? notificationsSettingsRappelsSubtitleMilo : notificationsSettingsRappelsSubtitleFT;
  static const String notificationsSettingsRappelsSubtitleMilo =
      "Rappel de complétion des actions (1 fois par semaine)";
  static const String notificationsSettingsRappelsSubtitleFT =
      "Rappel de complétion des démarches (1 fois par semaine)";

  static const String notificationsSettingsTitle = "Paramètres système";
  static const String openNotificationsSettings = "Ouvrir les paramètres de notifications";
  static const String notificationsA11yEnable = "Activer les notifications pour ";
  static const String notificationsA11yDisable = "Désactiver les notifications pour ";

  // contact page
  static String contactConseilsDepartementaux = "Conseil départemental";
  static String contactPageTitle = "Contacter l’équipe";
  static String contactPageBody1 = Brand.isCej()
      ? "L’équipe technique de l’application CEJ est en charge du développement de l’application."
      : "L’équipe technique de l’application pass emploi est en charge du développement de l’application.";
  static String contactPageBody2 = "Contactez-nous pour :";
  static String contactPageBody3 = Brand.isCej()
      ? "Pour toutes les informations et les problèmes liés au Contrat d’Engagement Jeune, veuillez contacter votre conseiller."
      : "Pour toutes les informations et les problèmes liés votre dispositif d'accompagnement, veuillez contacter votre conseiller.";
  static String contactPageBodyBullet1 = "Un problème sur l’application";
  static String contactPageBodyBullet2 = "Une suggestion d’évolution";
  static String contactPageBodyBullet3 = "Toute autre remarque";
  static String contactPageButton = "Contacter l'équipe";

  static String objetPriseDeContact(Brand brand) => brand.isCej
      ? "Prise de contact avec l’équipe de l’application du CEJ"
      : "Prise de contact avec l’équipe de l’application pass emploi";
  static String corpsPriseDeContact = "Décrivez nous votre problème ou vos suggestions d’évolution : ";

  // alertes
  static String createAlert = "Créer une alerte";
  static String createAlerteTitle = "Créer une alerte pour la recherche";
  static String alerteTitle = "Nom de la recherche";
  static String mandatoryAlerteTitleError = "Renseigner un nom pour votre recherche";
  static String alerteFilters = "Critères de la recherche";
  static String alerteInfo = "Les filtres appliqués seront aussi enregistrés.";
  static String searchNotificationInfo =
      "Vous recevrez des notifications pour être alerté des nouvelles offres liées aux critères de votre recherche.";

  static String alerteTitleField(metier, localisation) => "$metier - $localisation";
  static String alerteSuccessfullyCreated =
      "Votre recherche a bien été enregistrée. Retrouvez-la dans la section Mes Alertes sur votre page d'accueil.";
  static String creationAlerteError = "Erreur lors de la création de l'alerte. Veuillez réessayer";
  static String alerteGetError = "Erreur lors de la récupération des recherches sauvegardées.";
  static String alerteTabName = "Mes alertes";
  static String alertesListEmptyTitle = "Vous n’avez pas encore d’alerte sauvegardée";
  static String alertesListEmptySubtitle =
      "Créez des alertes lors de vos recherches et recevez les offres qui vous correspondent";
  static String alertesListEmptyButton = "Rechercher une offre";
  static String alertesFilteredListEmptyTitle = "Aucune alerte ne correspond à vos critères";
  static String alertesFilteredListEmptySubtitle = "Essayez de modifier vos filtres";
  static String favorisTabName = "Mes offres";
  static String alerteSeeResults = "Voir les résultats";

  static String alerteDeleteMessageTitle = "Souhaitez-vous supprimer l’alerte ?";
  static String alerteDeleteMessageSubtitle = "Vous n’aurez plus accès à la page de résultats ni aux notifications.";
  static String alerteDeleteError = "Erreur lors de la suppression de la recherche.";
  static String alerteDeleteSuccess = "Votre alerte a été supprimée avec succès.";

  // Mode démo
  static String passerEnDemo = "Passer en mode démo";
  static String modeDemoAppBarLabel = "Version démo conseiller";
  static String modeDemoExplicationTitre = "Espace démo conseiller";
  static String modeDemoExplicationPremierPoint1 = "→ Cette version vous ";
  static String modeDemoExplicationPremierPoint2 = "permet d’explorer";
  static String modeDemoExplicationPremierPoint3 = Brand.isCej()
      ? _CejStrings.modeDemoExplicationPremierPoint3
      : _PassEmploiStrings.modeDemoExplicationPremierPoint3;
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
  static String developerOptionFCM = 'Copier le token FCM';
  static String developerOptionFCMDelete = 'Supprimer le token FCM';
  static String developerOptionDeleteAllPrefs = 'Supprimer les données locales';
  static String developerOptionMatomoPage = 'Matomo';

  // Tutorial
  static String seeLater = "Voir plus tard";
  static String finish = "Terminer";

  //Appstore rating
  static String ratingLabel = 'Êtes-vous satisfait de l’application\u{00A0}?';
  static String ratingButton = 'Je donne mon avis';
  static String positiveRating = "Oui ! \nBeau boulot, j’adore l’app.";
  static String negativeRating = "Non... \nJ’ai quelques remarques.";
  static String happyEmoji = "😍";
  static String sadEmoji = "😫";

  static String supportMail = "support@pass-emploi.beta.gouv.fr";

  static String ratingEmailObject(Brand brand) =>
      brand.isCej ? "Mon avis sur l’application du CEJ" : "Mon avis sur l’application pass emploi";

  static String contentSupportMail = "Aidez-nous à améliorer l’application en nous donnant votre avis :\n";

  // Suggestions de recherche
  static String vosSuggestionsAlertesError = "Erreur lors de la récupération de vos suggestions d'alertes";
  static String vosSuggestionsAlertes = "Vos suggestions d'alertes";
  static String nouvellesSuggestionsDeRechercheTitre = "Vous avez des suggestions d’alertes";
  static String nouvellesSuggestionsDeRechercheDescription =
      "Sur la base de votre profil France Travail, voici des suggestions d'alertes à sauvegarder";
  static String voirSuggestionsDeRecherche = "Voir les suggestions";
  static String suggestionsDeRechercheHeader =
      "Vos suggestions peuvent venir de différentes sources. Après l’ajout, vous serez notifié si une nouvelle offre est disponible.";
  static String suggestionSourcePoleEmploi = "Profil France Travail";
  static String suggestionSourceConseiller = "Conseiller";
  static String suggestionSourceDiagoriente = "Métiers favoris";
  static String suggestionRechercheAjoutee = "Recherche ajoutée";
  static String suggestionRechercheAjouteeDescription = "La recherche a été ajoutée à vos offres suivies";
  static String voirResultatsSuggestion = "Voir les résultats";
  static String emptySuggestionAlerteListTitre = "Vous n’avez pas encore de suggestions d’alerte";
  static String emptySuggestionAlerteListDescriptionMilo =
      "Vous pouvez découvrir vos métiers favoris dans votre profil pour avoir des suggestions qui vous correspondent";
  static String emptySuggestionAlerteListDescriptionPoleEmploi =
      "Vous pouvez remplir votre profil France Travail et découvrir vos métiers favoris dans votre profil pour avoir des suggestions qui vous correspondent";

  // Événements
  static String eventListError = "Erreur lors de la récupération des événements";
  static String eventListEmpty = "Il n’y a pas encore d’évènement dans votre Mission Locale";
  static String eventListEmptySubtitle = "Vous retrouverez ici tous les événements programmés de votre mission locale";
  static String eventListHeaderText = "Retrouvez ici l’ensemble des événements organisés par votre Mission locale";
  static String eventVousEtesDejaInscrit = "Je suis déjà inscrit";
  static String eventInscrivezVousPourParticiper = "Faire une demande d'inscription";
  static String eventAutoInscription = "M'inscrire pour participer";
  static String eventComplet = "Complet";
  static String eventAppBarTitle = "Événements";
  static String eventTabMaMissionLocale = "Ma Mission Locale";
  static String eventTabExternes = "Externes";
  static String eventEmploiDetailsAppBarTitle = "Détail de l’événement";
  static String eventEmploiDetailsPartagerConseiller = "Partager l'événement à mon conseiller";
  static String eventEmploiDetailsInscription = "Je m'inscris";
  static String eventPlaceholderTitle = "Trouvez un événement";
  static String eventPlaceholderSubtitle = "Commencez votre recherche en remplissant les champs ci-dessus.";

  // Événements Emploi
  static const String secteurActiviteLabel = "Secteur d'activité";
  static const String secteurActiviteHint = "Sélectionnez un secteur d'activité";
  static const String secteurActiviteAll = "Tous les secteurs d'activité";
  static const String secteurActiviteAgriculture =
      "Agriculture et Pêche, Espaces naturels et Espaces verts, Soins aux animaux";
  static const String secteurActiviteArt = "Arts et Façonnage d'ouvrages d'art";
  static const String secteurActiviteBanque = "Banque, Assurance, Immobilier";
  static const String secteurActiviteCommerce = "Commerce, Vente et Grande distribution";
  static const String secteurActiviteCommunication = "Communication, Média et Multimédia";
  static const String secteurActiviteBatiment = "Construction, Bâtiment et Travaux publics";
  static const String secteurActiviteTourisme = "Hôtellerie-Restauration, Tourisme, Loisirs et Animation";
  static const String secteurActiviteIndustrie = "Industrie";
  static const String secteurActiviteInstallation = "Installation et Maintenance";
  static const String secteurActiviteSante = "Santé";
  static const String secteurActiviteServices = "Services à la personne et à la collectivité";
  static const String secteurActiviteSpectacle = "Spectacle";
  static const String secteurActiviteSupport = "Support à l'entreprise";
  static const String secteurActiviteTransport = "Transport et Logistique";
  static const String evenementEmploiTypeAll = "Tous les types d'événement";
  static const String evenementEmploiTypeReunionInformation = "Réunion d'information";
  static const String evenementEmploiTypeForum = "Forum";
  static const String evenementEmploiTypeConference = "Conférence";
  static const String evenementEmploiTypeAtelier = "Atelier";
  static const String evenementEmploiTypeSalonEnLigne = "Salon en ligne";
  static const String evenementEmploiTypeJobDating = "Job Dating";
  static const String evenementEmploiTypeVisiteEntreprise = "Visite d'entreprise";
  static const String evenementEmploiTypePortesOuvertes = "Portes ouvertes";
  static const String evenementEmploiModaliteEnPhysique = "En présentiel";
  static const String evenementEmploiModaliteADistance = "À distance";
  static const String evenementEmploiDetails = "Détail de l'événement";
  static const String evenementEmploiFiltres = "Filtrer les événements";
  static const String evenementEmploiFiltresModalites = "Modalités d'accès";
  static const String evenementEmploiFiltresType = "Par type d’événement";
  static const String evenementEmploiFiltresDate = "Période";
  static const String evenementEmploiFiltresDateDebut = "Date de début";
  static const String evenementEmploiFiltresDateFin = "Date de fin";

  // Mode dégradé France Travail
  static String reloadPage = "Recharger la page";

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
  static String diagorienteDiscoverCardTitle = "Diagoriente";
  static String diagorienteDiscoverCardSubtitle = "Explorer les métiers qui correspondent à mes centres d’intérêt";
  static String diagorienteMetiersFavorisCardTitle = "Retrouvez vos métiers favoris";
  static String diagorienteMetiersFavorisCardSubtitle = "Mes métiers favoris";
  static String diagorienteMetiersFavorisCardPressedTip = "Voir";
  static String diagorienteVoirplus = "Voir plus";
  static String diagorienteAffinerMesResultats = "Affiner mes résultats";
  static String diagorienteTerminerEtRetournerAuProfil = "Terminer et retourner au profil";

  // CV
  static String cvCardTitle = "CV";
  static String cvCardSubtitle =
      "Préparez vos prochaines candidatures en téléchargeant vos CV France Travail directement sur votre téléphone.";
  static String cvCadCaption = "Voir";
  static String cvListPageTitle = "CV";
  static String cvListPageSubtitle =
      "Téléchargez vos CV France Travail sur votre téléphone pour préparer votre candidature";
  static String cvError = "Erreur lors de la récupération des CVs France Travail";
  static String cvListEmptyTitle = "Vous n’avez pas de CV dans votre espace France Travail";
  static String cvListEmptySubitle =
      "Déposez votre CV dans votre espace France Travail pour le récupérer automatiquement quand vous postulerez à des offres";
  static String cvEmptyButton = "Mon espace France Travail";
  static String cvDownload = "Télécharger";
  static String cvErrorApiPeKoMessage = "Impossible de se synchroniser avec votre espace France Travail";
  static String cvErrorApiPeKoButton = "Recharger la page";

  // Postuler
  static String postulerOffreTitle = "Postuler";
  static String postulerTitle = "Récupérez votre CV sur votre téléphone";
  static String postulerContinueButton = "Continuez vers l’offre";

  // Suggestions alertes location form
  static String suggestionLocalisationAppBarTitle = "Paramétrer votre alerte";
  static String suggestionLocalisationFormEmploiSubtitle =
      "Sélectionnez une ville ou un département dans lequel vous cherchez un emploi.";
  static String suggestionLocalisationFormImmersionSubtitle =
      "Sélectionnez une ville dans laquelle vous cherchez une immersion.";
  static String suggestionLocalisationAddAlerteButton = "Ajouter l’alerte";

  // CGU
  static String cguNeverAcceptedTitle =
      Brand.isCej() ? "Bienvenue sur l’application du CEJ" : "Bienvenue sur l’application pass emploi";
  static String cguUpdateRequiredTitle = "Mise à jour des Conditions Générales d'Utilisation (CGU)";
  static List<String> cguNeverAcceptedDescription = [
    "L’utilisation de notre service est soumise à l’acception préalable de nos ",
    "↗ Conditions Générales d’Utilisation",
    ". Ces conditions définissent ",
    "vos droits et obligations en tant qu'utilisateur ",
    "de notre application.",
  ];
  static List<String> cguUpdateRequiredDescription = [
    "Nous avons mis à jour nos CGU le ",
    ". L’utilisation de notre service est soumise à l’acception préalable de nos ",
    "↗ CGU.",
    "\n\nPoints clés de la mise à jour :\n"
  ];
  static List<String> cguNeverAcceptedSwitch = [
    "J’ai lu et j’accepte les",
    " ↗ Conditions Générales d’Utilisation",
  ];
  static List<String> cguUpdateRequiredSwitch = [
    "J’ai lu et j’accepte les nouvelles",
    " ↗ CGU",
  ];
  static String cguSwitchError = "Acceptez les Conditions Générales d’Utilisation pour utiliser l’application.";
  static String cguAccept = "Valider";
  static String cguRefuse = "Refuser et se déconnecter";

  static String cguSwitchLabel(bool accepted) => accepted ? "Refuser les cgu" : "Accepter les cgu";

  // In-app feedback
  static String feedbackBad = "Pas d’accord";
  static String feedbackNeutral = "Neutre";
  static String feedbackGood = "D’accord";
  static String feedbackThanks = "Merci pour votre retour !";

  static String feedbackProvenanceOffre(String provenance) =>
      "Connaître la source d’une offre ($provenance, etc) m’intéresse.";
  static String feedbackCentreNotification = "Retrouver mes notifications dans l'app m'intéresse.";
  static String feedbackCreateDemarche = "Êtes vous satisfait de la nouvelle saisie des démarches ?";

  // centre de notifications
  static String notificationsCenterTooltip = "Centre de notifications";
  static String notificationsCenterTitle = "Notifications";
  static String notificationsCenterError = "Erreur lors de la récupération des notifications";
  static String notificationsCenterEmptyTitle = "Vous n’avez pas de nouvelle notification.";

  // a11y
  static String selectedRadioButton = "Sélectionné";
  static String unselectedRadioButton = "Non sélectionné";

  static String deleteSelection = "Supprimer la sélection";

  static String iconAlternativeLocation = "Localisation";
  static String iconAlternativeContractType = "Type de contrat";
  static String iconAlternativeSalary = "Salaire";
  static String iconAlternativeDuration = "Temps de travail";
  static String iconAlternativeDateDeDebut = "Date de début";
  static String iconAlternativeDateDeFin = "Date de fin";
  static String a11yHours = " heures ";
  static String a11yMinutes = " minutes ";
  static String a11yDuration = "durée : ";
  static String a11yMonday = "lundi";
  static String a11yTuesday = "mardi";
  static String a11yWednesday = "mercredi";
  static String a11yThursday = "jeudi";
  static String a11yFriday = "vendredi";
  static String a11ySaturday = "samedi";
  static String a11ySunday = "dimanche";
  static String a11yJanuary = " janvier ";
  static String a11yFebruary = " février ";
  static String a11yMarch = " mars ";
  static String a11yApril = " avril ";
  static String a11yMay = " mai ";
  static String a11yJune = " juin ";
  static String a11yJuly = " juillet ";
  static String a11yAugust = " août ";
  static String a11ySeptember = " septembre ";
  static String a11yOctober = " octobre ";
  static String a11yNovember = " novembre ";
  static String a11yDecember = " décembre ";

  static String a11yStatus = "Statut : ";

  // textes alternatifs
  static String offreEnregistreeRemove(String offre) => "Retirer l'offre $offre des offres suivies";

  static String offreEnregistreeAdd(String offre) => "Enregistrer l'offre $offre";
  static String link = "Lien";
  static String openInNewTab = "Ouvrir dans un nouvel onglet";
  static String semanticsLabelInformation = "Information";
  static String invalidField = "Champ invalide";
  static String loadingAnnouncement = "Chargement en cours";
  static String closeDialog = "Fermer la boîte de dialogue";
  static String closeInformationMessage = "Fermer le message d'information";
  static String chosenValue = "Valeur choisie :";
  static String buttonRole = "bouton";
  static String bottomSheetBarrierLabel = "$closeDialog, $buttonRole";
  static String source = "Source : ";
  static const String moodBad = "Emoticone pas d’accord du tout";
  static const String sentimentDissatisfied = "Emoticone plutôt pas d’accord";
  static const String sentimentNeutral = "Emoticone neutre";
  static const String sentimentSatisfied = "Emoticone plutôt d’accord";
  static const String mood = "Emoticone d’accord";
  static const String emptyDate = "Aucune date sélectionnée";

  static String removeDistance(int value) => 'Diminuer la distance de $value km';

  static String addDistance(int value) => 'Augmenter la distance de $value km';

  static String distanceUpdated(int value) => 'Distance mise à jour à $value km';

  static String listOffres = "Liste des offres";

  // Autoinscription
  static String demandeInscriptionConfirmationTitle = "Demande d'inscription";
  static String demandeInscriptionError = "Erreur lors de la demande d'inscription";
  static String demandeInscriptionErrorButton = "Revenir au détail";
  static String demandeInscriptionDescription =
      "Votre demande d’inscription à l’événement a été envoyée à votre conseiller";
  static String consulterAutresEvennements = "Consulter d’autres événements";
  static String nombreDePlacesInssufisantesError =
      "Cet événement est victime de son succès. Il n'y a plus de place disponible.";
  static String conseillerInactifError = "Votre conseiller est inactif";
  static String autoInscriptionConfirmation(String eventTitle) =>
      "Votre inscription à l’événement $eventTitle est confirmée";
  static String autoInscriptionContent = "Bravo pour votre engagement !";

  // Suivi des offres
  static String offreSuivieBottomSheetTitle = "Avez-vous postulé à cette offre ?";
  static String offreSuivieOuiPostule = "Oui, j’ai postulé";
  static String offreSuiviePasEncore = "Pas encore, mais ça m’intéresse";
  static String offreSuivieNonPasInteresse = "Non, ça ne m’intéresse plus";

  static String offrePostuleeConfirmationAppBar = "Offre postulée";
  static String offreFavorisConfirmationAppBar = "Offre enregistrée";
  static String offreSuivieConfirmationPageTitle = "Retrouvez cette offre dans votre suivi des offres";
  static String offreSuivieConfirmationPageDescription = "👏 Bravo pour votre engagement !";
  static String youConsultedThisOfferAt(String timeAgo) => "Vous avez consulté cette offre $timeAgo";
  static String ouEnEtesVous = "Où en êtes-vous ?";

  static String jaiPostule = "J’ai postulé";
  static String caMinteresse = "Ça m’intéresse";
  static String caNeMinteressePas = "Ça ne m’intéresse plus";
  static String retrouvezCetteOffreDansVosOffres = "Retrouvez cette offre dans le suivi des offres";
  static String seeNextOffer = "Voir l’offre suivante";
  static String merciPourVotreReponse = "Merci pour votre réponse";
  static String suivezVosOffres = "Suivez vos offres";
  static String suivezVosOffresDescription = "Retrouvez ici les offres auxquelles vous avez postulé";
}
