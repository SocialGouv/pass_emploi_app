import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/redux/store_factory.dart';
import 'package:pass_emploi_app/repositories/accueil_repository.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_delete_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/get_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/immersion_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/offre_emploi_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/service_civique_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/animations_collectives_repository.dart';
import 'package:pass_emploi_app/repositories/auth/chat_security_repository.dart';
import 'package:pass_emploi_app/repositories/auto_inscription_repository.dart';
import 'package:pass_emploi_app/repositories/backend_config_repository.dart';
import 'package:pass_emploi_app/repositories/boulanger_campagne_repository.dart';
import 'package:pass_emploi_app/repositories/campagne_recrutement_repository.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/comptage_des_heures_repository.dart';
import 'package:pass_emploi_app/repositories/configuration_application_repository.dart';
import 'package:pass_emploi_app/repositories/contact_immersion_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_encryption_local_storage.dart';
import 'package:pass_emploi_app/repositories/cv_repository.dart';
import 'package:pass_emploi_app/repositories/date_consultation_notification_repository.dart';
import 'package:pass_emploi_app/repositories/date_consultation_offre_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/derniere_offre_consultee_repository.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/developer_option_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_urls_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_engagement/evenement_engagement_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/first_launch_onboarding_repository.dart';
import 'package:pass_emploi_app/repositories/ia_ft_suggestions_repository.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/in_app_feedback_repository.dart';
import 'package:pass_emploi_app/repositories/in_app_notifications_repository.dart';
import 'package:pass_emploi_app/repositories/localisation_persist_repository.dart';
import 'package:pass_emploi_app/repositories/matching_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:pass_emploi_app/repositories/module_feedback_repository.dart';
import 'package:pass_emploi_app/repositories/mon_suivi_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/offres_suivies_repository.dart';
import 'package:pass_emploi_app/repositories/onboarding_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/repositories/preferences_repository.dart';
import 'package:pass_emploi_app/repositories/preferred_login_mode_repository.dart';
import 'package:pass_emploi_app/repositories/rating_repository.dart';
import 'package:pass_emploi_app/repositories/recherches_recentes_repository.dart';
import 'package:pass_emploi_app/repositories/remote_campagne_accueil_repository.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_details_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/top_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_pending_creation_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/usecases/piece_jointe/piece_jointe_use_case.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/wrappers/connectivity_wrapper.dart';
/*AUTOGENERATE-REDUX-TEST-SETUP-REPOSITORY-IMPORT*/
import 'package:redux/redux.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../doubles/mocks.dart';

class TestStoreFactory {
  final Configuration _configuration = configuration();
  Authenticator authenticator = DummyAuthenticator();
  UserActionRepository userActionRepository = DummyUserActionRepository();
  UserActionPendingCreationRepository userActionPendingCreationRepository = MockUserActionPendingCreationRepository();
  RendezvousRepository rendezvousRepository = MockRendezvousRepository();
  ChatRepository chatRepository = DummyChatRepository();
  PassEmploiCacheManager cacheManager = DummyPassEmploiCacheManager();
  ConnectivityWrapper connectivityWrapper = MockConnectivityWrapper();
  PushNotificationManager pushNotificationManager = MockPushNotificationManager();
  RemoteConfigRepository remoteConfigRepository = MockRemoteConfigRepository();
  BackendConfigRepository backendConfigRepository = MockBackendConfigRepository();
  DeveloperOptionRepository developerOptionRepository = MockDeveloperOptionRepository();
  OffreEmploiRepository offreEmploiRepository = DummyOffreEmploiRepository();
  OffreEmploiDetailsRepository detailedOfferRepository = DummyDetailedRepository();
  ConfigurationApplicationRepository registerTokenRepository = DummyRegisterTokenRepository();
  Crashlytics crashlytics = DummyCrashlytics();
  OffreEmploiFavorisRepository offreEmploiFavorisRepository = DummyOffreEmploiFavorisRepository();
  SearchLocationRepository searchLocationRepository = DummySearchLocationRepository();
  MetierRepository metierRepository = DummyMetierRepository();
  ImmersionRepository immersionRepository = DummyImmersionRepository();
  ImmersionDetailsRepository immersionDetailsRepository = DummyImmersionDetailsRepository();
  ImmersionFavorisRepository immersionFavorisRepository = DummyImmersionFavorisRepository();
  ChatSecurityRepository chatSecurityRepository = DummyChatSecurityRepository();
  FirebaseAuthWrapper firebaseAuthWrapper = DummyFirebaseAuthWrapper();
  ChatCrypto chatCrypto = DummyChatCrypto();
  ChatEncryptionLocalStorage cryptoStorage = DummyCryptoStorage();
  EvenementEngagementRepository evenementEngagementRepository = DummyEvenementEngagementRepository();
  OffreEmploiAlerteRepository offreEmploiAlerteRepository = DummyOffreEmploiAlerteRepository();
  ImmersionAlerteRepository immersionAlerteRepository = DummyImmersionAlerteRepository();
  ServiceCiviqueAlerteRepository serviceCiviqueAlerteRepository = DummyServiceCiviqueAlerteRepository();
  GetAlerteRepository getAlerteRepository = DummyGetAlerteRepository();
  AlerteDeleteRepository alerteDeleteRepository = DummyAlerteDeleteRepository();
  ServiceCiviqueRepository serviceCiviqueRepository = DummyServiceCiviqueRepository();
  ServiceCiviqueDetailRepository serviceCiviqueDetailRepository = DummyServiceCiviqueDetailRepository();
  ServiceCiviqueFavorisRepository serviceCiviqueFavorisRepository = DummyServiceCiviqueFavorisRepository();
  DetailsJeuneRepository detailsJeuneRepository = MockDetailsJeuneRepository();
  SuppressionCompteRepository suppressionCompteRepository = DummySuppressionCompteRepository();
  CampagneRepository campagneRepository = DummyCampagneRepository();
  ModeDemoRepository demoRepository = ModeDemoRepository();
  PassEmploiMatomoTracker matomoTracker = MockMatomoTracker();
  UpdateDemarcheRepository updateDemarcheRepository = DummyUpdateDemarcheRepository();
  CreateDemarcheRepository createDemarcheRepository = DummySuccessCreateDemarcheRepository();
  SearchDemarcheRepository searchDemarcheRepository = DummyDemarcheDuReferentielRepository();
  PieceJointeRepository pieceJointeRepository = DummyPieceJointeRepository();
  TutorialRepository tutorialRepository = DummyTutorialRepository();
  PreferencesRepository preferencesRepository = MockPreferencesRepository();
  RatingRepository ratingRepository = DummyRatingRepository();
  ActionCommentaireRepository actionCommentaireRepository = DummyActionCommentaireRepository();
  SuggestionsRechercheRepository suggestionsRechercheRepository = DummySuggestionsRechercheRepository();
  AnimationsCollectivesRepository animationsCollectivesRepository = DummyAnimationsCollectivesRepository();
  SessionMiloRepository sessionMiloRepository = DummySessionMiloRepository();
  DiagorienteUrlsRepository diagorienteUrlsRepository = DummyDiagorienteUrlsRepository();
  DiagorienteMetiersFavorisRepository diagorienteMetiersFavorisRepository = DummyDiagorienteMetiersFavorisRepository();
  GetFavorisRepository getFavorisRepository = MockGetFavorisRepository();
  RecherchesRecentesRepository recherchesRecentesRepository = DummyRecherchesRecentesRepository();
  ContactImmersionRepository contactImmersionRepository = DummyContactImmersionRepository();
  AccueilRepository accueilRepository = DummyAccueilRepository();
  CvRepository cvRepository = DummyCvRepository();
  EvenementEmploiRepository evenementEmploiRepository = DummyEvenementEmploiRepository();
  EvenementEmploiDetailsRepository evenementEmploiDetailsRepository = DummyEvenementEmploiDetailsRepository();
  ThematiqueDemarcheRepository thematiquesDemarcheRepository = DummyThematiqueDemarcheRepository();
  TopDemarcheRepository topDemarcheRepository = DummyTopDemarcheRepository();
  MonSuiviRepository monSuiviRepository = DummyMonSuiviRepository();
  CampagneRecrutementRepository campagneRecrutementRepository = MockCampagneRecrutementRepository();
  PreferredLoginModeRepository preferredLoginModeRepository = MockPreferredLoginModeRepository();
  OnboardingRepository onboardingRepository = MockOnboardingRepository();
  FirstLaunchOnboardingRepository firstLaunchOnboardingRepository = MockFirstLaunchOnboardingRepository();
  PieceJointeUseCase pieceJointeUseCase = MockPieceJointeUseCase();
  MatchingDemarcheRepository matchingDemarcheRepository = MockMatchingDemarcheRepository();
  DateConsultationOffreRepository dateConsultationOffreRepository = MockDateConsultationOffreRepository();
  DerniereOffreConsulteeRepository derniereOffreConsulteeRepository = MockDerniereOffreConsulteeRepository();
  InAppFeedbackRepository inAppFeedbackRepository = MockInAppFeedbackRepository();
  InAppNotificationsRepository inAppNotificationsRepository = MockInAppNotificationsRepository();
  DateConsultationNotificationRepository dateConsultationNotificationRepository =
      MockDateConsultationNotificationRepository();
  LocalisationPersistRepository localisationPersistRepository = MockLocalisationPersistRepository();
  RemoteCampagneAccueilRepository remoteCampagneAccueilRepository = MockRemoteCampagneAccueilRepository();
  AutoInscriptionRepository autoInscriptionRepository = MockAutoInscriptionRepository();
  OffresSuiviesRepository offresSuiviesRepository = MockOffresSuiviesRepository();
  ComptageDesHeuresRepository comptageDesHeuresRepository = MockComptageDesHeuresRepository();
  BoulangerCampagneRepository boulangerCampagneRepository = MockBoulangerCampagneRepository();
  IaFtSuggestionsRepository iaFtSuggestionsRepository = MockIaFtSuggestionsRepository();
  ModuleFeedbackRepository moduleFeedbackRepository = MockModuleFeedbackRepository();
  /*AUTOGENERATE-REDUX-TEST-SETUP-REPOSITORY-PROPERTY*/

  Store<AppState> initializeReduxStore({required AppState initialState}) {
    return StoreFactory(
      _configuration,
      authenticator,
      crashlytics,
      chatCrypto,
      cryptoStorage,
      cacheManager,
      connectivityWrapper,
      pushNotificationManager,
      remoteConfigRepository,
      backendConfigRepository,
      developerOptionRepository,
      userActionRepository,
      userActionPendingCreationRepository,
      rendezvousRepository,
      offreEmploiRepository,
      chatRepository,
      registerTokenRepository,
      detailedOfferRepository,
      offreEmploiFavorisRepository,
      immersionFavorisRepository,
      serviceCiviqueFavorisRepository,
      searchLocationRepository,
      metierRepository,
      immersionRepository,
      immersionDetailsRepository,
      chatSecurityRepository,
      firebaseAuthWrapper,
      evenementEngagementRepository,
      offreEmploiAlerteRepository,
      immersionAlerteRepository,
      serviceCiviqueAlerteRepository,
      getAlerteRepository,
      alerteDeleteRepository,
      serviceCiviqueRepository,
      serviceCiviqueDetailRepository,
      detailsJeuneRepository,
      suppressionCompteRepository,
      demoRepository,
      campagneRepository,
      matomoTracker,
      updateDemarcheRepository,
      createDemarcheRepository,
      searchDemarcheRepository,
      pieceJointeRepository,
      tutorialRepository,
      preferencesRepository,
      ratingRepository,
      actionCommentaireRepository,
      suggestionsRechercheRepository,
      animationsCollectivesRepository,
      sessionMiloRepository,
      diagorienteUrlsRepository,
      diagorienteMetiersFavorisRepository,
      getFavorisRepository,
      recherchesRecentesRepository,
      contactImmersionRepository,
      accueilRepository,
      cvRepository,
      evenementEmploiRepository,
      evenementEmploiDetailsRepository,
      thematiquesDemarcheRepository,
      topDemarcheRepository,
      monSuiviRepository,
      campagneRecrutementRepository,
      preferredLoginModeRepository,
      onboardingRepository,
      firstLaunchOnboardingRepository,
      pieceJointeUseCase,
      matchingDemarcheRepository,
      dateConsultationOffreRepository,
      derniereOffreConsulteeRepository,
      inAppFeedbackRepository,
      inAppNotificationsRepository,
      dateConsultationNotificationRepository,
      localisationPersistRepository,
      remoteCampagneAccueilRepository,
      autoInscriptionRepository,
      offresSuiviesRepository,
      comptageDesHeuresRepository,
      boulangerCampagneRepository,
      iaFtSuggestionsRepository,
      moduleFeedbackRepository,
      /*AUTOGENERATE-REDUX-TEST-SETUP-REPOSITORY-CONSTRUCTOR*/
    ).initializeReduxStore(initialState: initialState);
  }
}
