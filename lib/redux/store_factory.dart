import 'package:flutter/foundation.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/accueil/accueil_middleware.dart';
import 'package:pass_emploi_app/features/agenda/agenda_middleware.dart';
import 'package:pass_emploi_app/features/alerte/create/immersion_alerte_create_middleware.dart';
import 'package:pass_emploi_app/features/alerte/create/offre_emploi_alerte_create_middleware.dart';
import 'package:pass_emploi_app/features/alerte/create/service_civique_alerte_create_middleware.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_middleware.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_middleware.dart';
import 'package:pass_emploi_app/features/alerte/init/alerte_initialize_middleware.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_middleware.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_middleware.dart';
import 'package:pass_emploi_app/features/cache/cache_invalidator_middleware.dart';
import 'package:pass_emploi_app/features/campagne/campagne_middleware.dart';
import 'package:pass_emploi_app/features/chat/init/chat_initializer_middleware.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_middleware.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_middleware.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_middleware.dart';
import 'package:pass_emploi_app/features/connectivity/connectivity_middleware.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_middleware.dart';
import 'package:pass_emploi_app/features/cv/cv_middleware.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_middleware.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_middleware.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_middleware.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_middleware.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_middleware.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_middleware.dart';
import 'package:pass_emploi_app/features/developer_option/matomo/matomo_logging_middleware.dart';
import 'package:pass_emploi_app/features/device_info/device_info_middleware.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_middleware.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_middleware.dart';
import 'package:pass_emploi_app/features/events/list/event_list_middleware.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_middleware.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_middleware.dart';
import 'package:pass_emploi_app/features/favori/update/data_from_id_extractor.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_middleware.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_middleware.dart';
import 'package:pass_emploi_app/features/location/search_location_middleware.dart';
import 'package:pass_emploi_app/features/login/login_middleware.dart';
import 'package:pass_emploi_app/features/metier/search_metier_middleware.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_middleware.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_middleware.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activite_middleware.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_middleware.dart';
import 'package:pass_emploi_app/features/push/register_push_notification_token_middleware.dart';
import 'package:pass_emploi_app/features/rating/rating_middleware.dart';
import 'package:pass_emploi_app/features/recherche/emploi/recherche_emploi_middleware.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/recherche_evenement_emploi_middleware.dart';
import 'package:pass_emploi_app/features/recherche/immersion/recherche_immersion_middleware.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/recherche_service_civique_middleware.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_middleware.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_middleware.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_middleware.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_middleware.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_middleware.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_middleware.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_middleware.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_middleware.dart';
import 'package:pass_emploi_app/features/tech/action_logging_middleware.dart';
import 'package:pass_emploi_app/features/tech/crashlytics_middleware.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_middleware.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_middleware.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_middleware.dart';
import 'package:pass_emploi_app/features/tracking/tracking_setup_middleware.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_middleware.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_middleware.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_middleware.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_middleware.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_middleware.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_middleware.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_middleware.dart';
/*AUTOGENERATE-REDUX-STOREFACTORY-IMPORT-MIDDLEWARE*/
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/accueil_repository.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_delete_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/get_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/immersion_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/offre_emploi_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/service_civique_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/animations_collectives_repository.dart';
import 'package:pass_emploi_app/repositories/auth/chat_security_repository.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/configuration_application_repository.dart';
import 'package:pass_emploi_app/repositories/contact_immersion_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_encryption_local_storage.dart';
import 'package:pass_emploi_app/repositories/cv_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_urls_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:pass_emploi_app/repositories/mon_suivi_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/repositories/rating_repository.dart';
import 'package:pass_emploi_app/repositories/recherches_recentes_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_details_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/top_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_pending_creation_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/wrappers/connectivity_wrapper.dart';
/*AUTOGENERATE-REDUX-STOREFACTORY-IMPORT-REPOSITORY*/
import 'package:redux/redux.dart' as redux;

class StoreFactory {
  final Configuration configuration;
  final Authenticator authenticator;
  final Crashlytics crashlytics;
  final ChatCrypto chatCrypto;
  final ChatEncryptionLocalStorage cryptoStorage;
  final PassEmploiCacheManager cacheManager;
  final ConnectivityWrapper connectivityWrapper;
  final UserActionRepository userActionRepository;
  final UserActionPendingCreationRepository userActionPendingCreationRepository;
  final PageDemarcheRepository pageDemarcheRepository;
  final RendezvousRepository rendezvousRepository;
  final OffreEmploiRepository offreEmploiRepository;
  final ChatRepository chatRepository;
  final ConfigurationApplicationRepository registerTokenRepository;
  final OffreEmploiDetailsRepository offreEmploiDetailsRepository;
  final OffreEmploiFavorisRepository offreEmploiFavorisRepository;
  final ImmersionFavorisRepository immersionFavorisRepository;
  final ServiceCiviqueFavorisRepository serviceCiviqueFavorisRepository;
  final SearchLocationRepository searchLocationRepository;
  final MetierRepository metierRepository;
  final ImmersionRepository immersionRepository;
  final ImmersionDetailsRepository immersionDetailsRepository;
  final ChatSecurityRepository chatSecurityRepository;
  final FirebaseAuthWrapper firebaseAuthWrapper;
  final TrackingEventRepository trackingEventRepository;
  final OffreEmploiAlerteRepository offreEmploiAlerteRepository;
  final ImmersionAlerteRepository immersionAlerteRepository;
  final ServiceCiviqueAlerteRepository serviceCiviqueAlerteRepository;
  final GetAlerteRepository getAlerteRepository;
  final AlerteDeleteRepository alerteDeleteRepository;
  final ServiceCiviqueRepository serviceCiviqueRepository;
  final ServiceCiviqueDetailRepository serviceCiviqueDetailRepository;
  final DetailsJeuneRepository detailsJeuneRepository;
  final SuppressionCompteRepository suppressionCompteRepository;
  final ModeDemoRepository modeDemoRepository;
  final CampagneRepository campagneRepository;
  final PassEmploiMatomoTracker matomoTracker;
  final UpdateDemarcheRepository updateDemarcheRepository;
  final CreateDemarcheRepository createDemarcheRepository;
  final SearchDemarcheRepository demarcheDuReferentielRepository;
  final PieceJointeRepository pieceJointeRepository;
  final TutorialRepository tutorialRepository;
  final PartageActiviteRepository partageActiviteRepository;
  final RatingRepository ratingRepository;
  final ActionCommentaireRepository actionCommentaireRepository;
  final AgendaRepository agendaRepository;
  final SuggestionsRechercheRepository suggestionsRechercheRepository;
  final AnimationsCollectivesRepository animationsCollectivesRepository;
  final SessionMiloRepository sessionMiloRepository;
  final InstallationIdRepository installationIdRepository;
  final DiagorienteUrlsRepository diagorienteUrlsRepository;
  final DiagorienteMetiersFavorisRepository diagorienteMetiersFavorisRepository;
  final GetFavorisRepository getFavorisRepository;
  final RecherchesRecentesRepository recherchesRecentesRepository;
  final ContactImmersionRepository contactImmersionRepository;
  final AccueilRepository accueilRepository;
  final CvRepository cvRepository;
  final EvenementEmploiRepository evenementEmploiRepository;
  final EvenementEmploiDetailsRepository evenementEmploiDetailsRepository;
  final ThematiqueDemarcheRepository thematiquesDemarcheRepository;
  final TopDemarcheRepository topDemarcheRepository;
  final MonSuiviRepository monSuiviRepository;

  /*AUTOGENERATE-REDUX-STOREFACTORY-PROPERTY-REPOSITORY*/

  StoreFactory(
    this.configuration,
    this.authenticator,
    this.crashlytics,
    this.chatCrypto,
    this.cryptoStorage,
    this.cacheManager,
    this.connectivityWrapper,
    this.userActionRepository,
    this.userActionPendingCreationRepository,
    this.pageDemarcheRepository,
    this.rendezvousRepository,
    this.offreEmploiRepository,
    this.chatRepository,
    this.registerTokenRepository,
    this.offreEmploiDetailsRepository,
    this.offreEmploiFavorisRepository,
    this.immersionFavorisRepository,
    this.serviceCiviqueFavorisRepository,
    this.searchLocationRepository,
    this.metierRepository,
    this.immersionRepository,
    this.immersionDetailsRepository,
    this.chatSecurityRepository,
    this.firebaseAuthWrapper,
    this.trackingEventRepository,
    this.offreEmploiAlerteRepository,
    this.immersionAlerteRepository,
    this.serviceCiviqueAlerteRepository,
    this.getAlerteRepository,
    this.alerteDeleteRepository,
    this.serviceCiviqueRepository,
    this.serviceCiviqueDetailRepository,
    this.detailsJeuneRepository,
    this.suppressionCompteRepository,
    this.modeDemoRepository,
    this.campagneRepository,
    this.matomoTracker,
    this.updateDemarcheRepository,
    this.createDemarcheRepository,
    this.demarcheDuReferentielRepository,
    this.pieceJointeRepository,
    this.tutorialRepository,
    this.partageActiviteRepository,
    this.ratingRepository,
    this.actionCommentaireRepository,
    this.agendaRepository,
    this.suggestionsRechercheRepository,
    this.animationsCollectivesRepository,
    this.sessionMiloRepository,
    this.installationIdRepository,
    this.diagorienteUrlsRepository,
    this.diagorienteMetiersFavorisRepository,
    this.getFavorisRepository,
    this.recherchesRecentesRepository,
    this.contactImmersionRepository,
    this.accueilRepository,
    this.cvRepository,
    this.evenementEmploiRepository,
    this.evenementEmploiDetailsRepository,
    this.thematiquesDemarcheRepository,
    this.topDemarcheRepository,
    this.monSuiviRepository,
    /*AUTOGENERATE-REDUX-STOREFACTORY-CONSTRUCTOR-REPOSITORY*/
  );

  redux.Store<AppState> initializeReduxStore({required AppState initialState}) {
    return redux.Store<AppState>(
      reducer,
      initialState: initialState,
      middleware: [
        CrashlyticsMiddleware(crashlytics, installationIdRepository).call,
        BootstrapMiddleware().call,
        LoginMiddleware(authenticator, firebaseAuthWrapper, modeDemoRepository, matomoTracker).call,
        CacheInvalidatorMiddleware(cacheManager).call,
        UserActionListMiddleware(userActionRepository).call,
        UserActionCreateMiddleware(userActionRepository).call,
        UserActionCreatePendingMiddleware(userActionRepository, userActionPendingCreationRepository).call,
        UserActionUpdateMiddleware(userActionRepository).call,
        UserActionDeleteMiddleware(userActionRepository).call,
        DemarcheListMiddleware(pageDemarcheRepository).call,
        CreateDemarcheMiddleware(createDemarcheRepository).call,
        UpdateDemarcheMiddleware(updateDemarcheRepository).call,
        SearchDemarcheMiddleware(demarcheDuReferentielRepository).call,
        DetailsJeuneMiddleware(detailsJeuneRepository).call,
        ChatInitializerMiddleware(
          chatSecurityRepository,
          firebaseAuthWrapper,
          chatCrypto,
          modeDemoRepository,
          cryptoStorage,
        ).call,
        ChatMiddleware(chatRepository).call,
        ChatStatusMiddleware(chatRepository).call,
        RendezvousListMiddleware(rendezvousRepository, sessionMiloRepository).call,
        RendezvousDetailsMiddleware(rendezvousRepository).call,
        RegisterPushNotificationTokenMiddleware(registerTokenRepository, configuration).call,
        OffreEmploiDetailsMiddleware(offreEmploiDetailsRepository).call,
        FavoriIdsMiddleware<OffreEmploi>(offreEmploiFavorisRepository).call,
        FavoriUpdateMiddleware<OffreEmploi>(offreEmploiFavorisRepository, OffreEmploiDataFromIdExtractor()).call,
        FavoriIdsMiddleware<Immersion>(immersionFavorisRepository).call,
        FavoriUpdateMiddleware<Immersion>(immersionFavorisRepository, ImmersionDataFromIdExtractor()).call,
        FavoriIdsMiddleware<ServiceCivique>(serviceCiviqueFavorisRepository).call,
        FavoriUpdateMiddleware<ServiceCivique>(
          serviceCiviqueFavorisRepository,
          ServiceCiviqueDataFromIdExtractor(),
        ).call,
        SearchLocationMiddleware(searchLocationRepository).call,
        SearchMetierMiddleware(metierRepository).call,
        TrackingEventMiddleware(trackingEventRepository).call,
        TrackingSetupMiddleware(matomoTracker).call,
        ImmersionDetailsMiddleware(immersionDetailsRepository).call,
        OffreEmploiAlerteCreateMiddleware(offreEmploiAlerteRepository).call,
        ImmersionAlerteCreateMiddleware(immersionAlerteRepository).call,
        ServiceCiviqueAlerteCreateMiddleware(serviceCiviqueAlerteRepository).call,
        AlerteInitializeMiddleware().call,
        AlerteListMiddleware(getAlerteRepository).call,
        AlerteGetMiddleware(getAlerteRepository).call,
        AlerteDeleteMiddleware(alerteDeleteRepository).call,
        ServiceCiviqueDetailMiddleware(serviceCiviqueDetailRepository).call,
        SuppressionCompteMiddleware(suppressionCompteRepository).call,
        CampagneMiddleware(campagneRepository).call,
        PieceJointeMiddleware(pieceJointeRepository).call,
        TutorialMiddleware(tutorialRepository).call,
        PartageActiviteMiddleware(partageActiviteRepository).call,
        PartageActiviteUpdateMiddleware(partageActiviteRepository).call,
        RatingMiddleware(ratingRepository, detailsJeuneRepository).call,
        ActionCommentaireListMiddleware(actionCommentaireRepository).call,
        AgendaMiddleware(agendaRepository).call,
        SuggestionsRechercheMiddleware(suggestionsRechercheRepository).call,
        TraiterSuggestionRechercheMiddleware(suggestionsRechercheRepository).call,
        EventListMiddleware(animationsCollectivesRepository, sessionMiloRepository).call,
        DeviceInfoMiddleware(installationIdRepository).call,
        RechercheEmploiMiddleware(offreEmploiRepository).call,
        RechercheImmersionMiddleware(immersionRepository).call,
        RechercheServiceCiviqueMiddleware(serviceCiviqueRepository).call,
        RechercheEvenementEmploiMiddleware(evenementEmploiRepository).call,
        DiagorientePreferencesMetierMiddleware(diagorienteUrlsRepository, diagorienteMetiersFavorisRepository).call,
        FavoriListMiddleware(getFavorisRepository).call,
        RecherchesRecentesMiddleware(recherchesRecentesRepository).call,
        ContactImmersionMiddleware(contactImmersionRepository).call,
        AccueilMiddleware(accueilRepository).call,
        CvMiddleware(cvRepository).call,
        EvenementEmploiDetailsMiddleware(evenementEmploiDetailsRepository).call,
        ThematiqueDemarcheMiddleware(thematiquesDemarcheRepository).call,
        TopDemarcheMiddleware(topDemarcheRepository).call,
        SessionMiloDetailsMiddleware(sessionMiloRepository).call,
        ConnectivityMiddleware(connectivityWrapper, modeDemoRepository).call,
        MonSuiviMiddleware(monSuiviRepository).call,
        /*AUTOGENERATE-REDUX-STOREFACTORY-ADD-MIDDLEWARE*/
        ..._debugMiddlewares(),
        ..._stagingMiddlewares(initialState.configurationState.getFlavor()),
      ],
    );
  }

  List<redux.Middleware<AppState>> _debugMiddlewares() {
    if (kReleaseMode) return [];
    return [ActionLoggingMiddleware().call];
  }

  List<redux.Middleware<AppState>> _stagingMiddlewares(Flavor flavor) {
    if (flavor == Flavor.PROD) return [];
    return [DeveloperOptionsMiddleware().call, MatomoLoggingMiddleware().call];
  }
}
