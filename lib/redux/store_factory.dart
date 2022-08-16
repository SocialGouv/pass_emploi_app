import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_middleware.dart';
import 'package:pass_emploi_app/features/campagne/campagne_middleware.dart';
import 'package:pass_emploi_app/features/chat/init/chat_initializer_middleware.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_middleware.dart';
import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_middleware.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_middleware.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_middleware.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_middleware.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_middleware.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_middleware.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_middleware.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_middleware.dart';
import 'package:pass_emploi_app/features/developer_option/matomo/matomo_logging_middleware.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_middleware.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_middleware.dart';
import 'package:pass_emploi_app/features/favori/update/data_from_id_extractor.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_middleware.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_middleware.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_middleware.dart';
import 'package:pass_emploi_app/features/immersion/saved_search/immersion_saved_search_middleware.dart';
import 'package:pass_emploi_app/features/location/search_location_middleware.dart';
import 'package:pass_emploi_app/features/login/login_middleware.dart';
import 'package:pass_emploi_app/features/metier/search_metier_middleware.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_middleware.dart';
import 'package:pass_emploi_app/features/offre_emploi/saved_search/offre_emploi_saved_search_middleware.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_middleware.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activite_middleware.dart';
import 'package:pass_emploi_app/features/partage_activite/update/partage_activite_update_middleware.dart';
import 'package:pass_emploi_app/features/push/register_push_notification_token_middleware.dart';
import 'package:pass_emploi_app/features/rating/rating_middleware.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_middleware.dart';
import 'package:pass_emploi_app/features/saved_search/create/immersion_saved_search_create_middleware.dart';
import 'package:pass_emploi_app/features/saved_search/create/offre_emploi_saved_search_create_middleware.dart';
import 'package:pass_emploi_app/features/saved_search/create/service_civique_saved_search_create_middleware.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_middleware.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_middleware.dart';
import 'package:pass_emploi_app/features/saved_search/init/saved_search_initialize_middleware.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_middleware.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_middleware.dart';
import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_middleware.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_middleware.dart';
import 'package:pass_emploi_app/features/tech/action_logging_middleware.dart';
import 'package:pass_emploi_app/features/tech/crashlytics_middleware.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_middleware.dart';
import 'package:pass_emploi_app/features/tracking/user_tracking_structure_middleware.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_middleware.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_middleware.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_middleware.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_middleware.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_middleware.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_middleware.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/auth/firebase_auth_repository.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/repositories/rating_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/immersion_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/offre_emploi_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_delete_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/service_civique_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';
import 'package:redux/redux.dart' as redux;

class StoreFactory {
  final Authenticator authenticator;
  final Crashlytics crashlytics;
  final ChatCrypto chatCrypto;
  final PageActionRepository pageActionRepository;
  final PageDemarcheRepository pageDemarcheRepository;
  final RendezvousRepository rendezvousRepository;
  final OffreEmploiRepository offreEmploiRepository;
  final ChatRepository chatRepository;
  final RegisterTokenRepository registerTokenRepository;
  final OffreEmploiDetailsRepository offreEmploiDetailsRepository;
  final OffreEmploiFavorisRepository offreEmploiFavorisRepository;
  final ImmersionFavorisRepository immersionFavorisRepository;
  final ServiceCiviqueFavorisRepository serviceCiviqueFavorisRepository;
  final SearchLocationRepository searchLocationRepository;
  final MetierRepository metierRepository;
  final ImmersionRepository immersionRepository;
  final ImmersionDetailsRepository immersionDetailsRepository;
  final FirebaseAuthRepository firebaseAuthRepository;
  final FirebaseAuthWrapper firebaseAuthWrapper;
  final TrackingEventRepository trackingEventRepository;
  final OffreEmploiSavedSearchRepository offreEmploiSavedSearchRepository;
  final ImmersionSavedSearchRepository immersionSavedSearchRepository;
  final ServiceCiviqueSavedSearchRepository serviceCiviqueSavedSearchRepository;
  final GetSavedSearchRepository getSavedSearchRepository;
  final SavedSearchDeleteRepository savedSearchDeleteRepository;
  final ServiceCiviqueRepository serviceCiviqueRepository;
  final ServiceCiviqueDetailRepository serviceCiviqueDetailRepository;
  final DetailsJeuneRepository detailsJeuneRepository;
  final SuppressionCompteRepository suppressionCompteRepository;
  final ModeDemoRepository modeDemoRepository;
  final CampagneRepository campagneRepository;
  final MatomoTracker matomoTracker;
  final FirebaseRemoteConfig? remoteConfig;
  final UpdateDemarcheRepository updateDemarcheRepository;
  final CreateDemarcheRepository createDemarcheRepository;
  final SearchDemarcheRepository demarcheDuReferentielRepository;
  final PieceJointeRepository pieceJointeRepository;
  final TutorialRepository tutorialRepository;
  final PartageActiviteRepository partageActiviteRepository;
  final RatingRepository ratingRepository;
  final ActionCommentaireRepository actionCommentaireRepository;

  StoreFactory(
    this.authenticator,
    this.crashlytics,
    this.chatCrypto,
    this.pageActionRepository,
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
    this.firebaseAuthRepository,
    this.firebaseAuthWrapper,
    this.trackingEventRepository,
    this.offreEmploiSavedSearchRepository,
    this.immersionSavedSearchRepository,
    this.serviceCiviqueSavedSearchRepository,
    this.getSavedSearchRepository,
    this.savedSearchDeleteRepository,
    this.serviceCiviqueRepository,
    this.serviceCiviqueDetailRepository,
    this.detailsJeuneRepository,
    this.suppressionCompteRepository,
    this.modeDemoRepository,
    this.campagneRepository,
    this.matomoTracker,
    this.remoteConfig,
    this.updateDemarcheRepository,
    this.createDemarcheRepository,
    this.demarcheDuReferentielRepository,
    this.pieceJointeRepository,
    this.tutorialRepository,
    this.partageActiviteRepository,
    this.ratingRepository,
    this.actionCommentaireRepository,
  );

  redux.Store<AppState> initializeReduxStore({required AppState initialState}) {
    return redux.Store<AppState>(
      reducer,
      initialState: initialState,
      middleware: [
        BootstrapMiddleware(),
        LoginMiddleware(authenticator, firebaseAuthWrapper, modeDemoRepository, matomoTracker),
        UserActionListMiddleware(pageActionRepository),
        UserActionCreateMiddleware(pageActionRepository),
        UserActionUpdateMiddleware(pageActionRepository),
        UserActionDeleteMiddleware(pageActionRepository),
        DemarcheListMiddleware(pageDemarcheRepository, remoteConfig),
        CreateDemarcheMiddleware(createDemarcheRepository),
        UpdateDemarcheMiddleware(updateDemarcheRepository),
        SearchDemarcheMiddleware(demarcheDuReferentielRepository),
        DetailsJeuneMiddleware(detailsJeuneRepository),
        ChatInitializerMiddleware(firebaseAuthRepository, firebaseAuthWrapper, chatCrypto, modeDemoRepository),
        ChatMiddleware(chatRepository),
        ChatStatusMiddleware(chatRepository),
        RendezvousMiddleware(rendezvousRepository),
        RegisterPushNotificationTokenMiddleware(registerTokenRepository),
        OffreEmploiMiddleware(offreEmploiRepository),
        OffreEmploiDetailsMiddleware(offreEmploiDetailsRepository),
        OffreEmploiSavedSearchMiddleware(offreEmploiRepository),
        FavoriIdsMiddleware<OffreEmploi>(offreEmploiFavorisRepository),
        FavoriListMiddleware<OffreEmploi>(offreEmploiFavorisRepository),
        FavoriUpdateMiddleware<OffreEmploi>(offreEmploiFavorisRepository, OffreEmploiDataFromIdExtractor()),
        FavoriIdsMiddleware<Immersion>(immersionFavorisRepository),
        FavoriListMiddleware<Immersion>(immersionFavorisRepository),
        FavoriUpdateMiddleware<Immersion>(immersionFavorisRepository, ImmersionDataFromIdExtractor()),
        FavoriIdsMiddleware<ServiceCivique>(serviceCiviqueFavorisRepository),
        FavoriListMiddleware<ServiceCivique>(serviceCiviqueFavorisRepository),
        FavoriUpdateMiddleware<ServiceCivique>(serviceCiviqueFavorisRepository, ServiceCiviqueDataFromIdExtractor()),
        RegisterPushNotificationTokenMiddleware(registerTokenRepository),
        CrashlyticsMiddleware(crashlytics),
        SearchLocationMiddleware(searchLocationRepository),
        SearchMetierMiddleware(metierRepository),
        TrackingEventMiddleware(trackingEventRepository),
        UserTrackingStructureMiddleware(),
        ImmersionListMiddleware(immersionRepository),
        ImmersionDetailsMiddleware(immersionDetailsRepository),
        ImmersionSavedSearchMiddleware(immersionRepository),
        OffreEmploiSavedSearchCreateMiddleware(offreEmploiSavedSearchRepository),
        ImmersionSavedSearchCreateMiddleware(immersionSavedSearchRepository),
        ServiceCiviqueSavedSearchCreateMiddleware(serviceCiviqueSavedSearchRepository),
        SavedSearchInitializeMiddleware(),
        SavedSearchListMiddleware(getSavedSearchRepository),
        SavedSearchGetMiddleware(getSavedSearchRepository),
        SavedSearchDeleteMiddleware(savedSearchDeleteRepository),
        SearchServiceCiviqueMiddleware(serviceCiviqueRepository),
        ServiceCiviqueDetailMiddleware(serviceCiviqueDetailRepository),
        SuppressionCompteMiddleware(suppressionCompteRepository),
        CampagneMiddleware(campagneRepository),
        PieceJointeMiddleware(pieceJointeRepository),
        TutorialMiddleware(tutorialRepository),
        PartageActiviteMiddleware(partageActiviteRepository),
        PartageActiviteUpdateMiddleware(partageActiviteRepository),
        RatingMiddleware(ratingRepository, detailsJeuneRepository),
        ActionCommentaireListMiddleware(actionCommentaireRepository),
        ..._debugMiddlewares(),
        ..._stagingMiddlewares(initialState.configurationState.getFlavor()),
      ],
    );
  }

  List<redux.Middleware<AppState>> _debugMiddlewares() {
    if (kReleaseMode) return [];
    return [ActionLoggingMiddleware()];
  }

  List<redux.Middleware<AppState>> _stagingMiddlewares(Flavor flavor) {
    if (flavor == Flavor.PROD) return [];
    return [DeveloperOptionsMiddleware(), MatomoLoggingMiddleware()];
  }
}
