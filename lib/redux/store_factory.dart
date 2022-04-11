import 'package:flutter/foundation.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_middleware.dart';
import 'package:pass_emploi_app/features/chat/init/chat_initializer_middleware.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_middleware.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_middleware.dart';
import 'package:pass_emploi_app/features/conseiller/conseiller_middleware.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_middleware.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_middleware.dart';
import 'package:pass_emploi_app/features/favori/update/data_from_id_extractor.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_middleware.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_middleware.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_middleware.dart';
import 'package:pass_emploi_app/features/immersion/saved_search/immersion_saved_search_middleware.dart';
import 'package:pass_emploi_app/features/location/search_location_middleware.dart';
import 'package:pass_emploi_app/features/login/login_middleware.dart';
import 'package:pass_emploi_app/features/login/pole_emploi/pole_emploi_auth_middleware.dart';
import 'package:pass_emploi_app/features/metier/search_metier_middleware.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_middleware.dart';
import 'package:pass_emploi_app/features/offre_emploi/saved_search/offre_emploi_saved_search_middleware.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_middleware.dart';
import 'package:pass_emploi_app/features/push/register_push_notification_token_middleware.dart';
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
import 'package:pass_emploi_app/features/tech/action_logging_middleware.dart';
import 'package:pass_emploi_app/features/tech/crashlytics_middleware.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_middleware.dart';
import 'package:pass_emploi_app/features/tracking/user_tracking_structure_middleware.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_middleware.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_middleware.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_middleware.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_middleware.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_middleware.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/auth/firebase_auth_repository.dart';
import 'package:pass_emploi_app/repositories/auth/pole_emploi/pole_emploi_auth_repository.dart';
import 'package:pass_emploi_app/repositories/auth/pole_emploi/pole_emploi_token_repository.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/conseiller_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
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
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_pe_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart' as redux;

class StoreFactory {
  final Authenticator authenticator;
  final Crashlytics crashlytics;
  final ChatCrypto chatCrypto;
  final PoleEmploiTokenRepository poleEmploiTokenRepository;
  final PoleEmploiAuthRepository poleEmploiAuthRepository;
  final UserActionRepository userActionRepository;
  final UserActionPERepository userActionPERepository;
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
  final ConseillerRepository conseillerRepository;
  final ModeDemoRepository modeDemoRepository;

  StoreFactory(
    this.authenticator,
    this.crashlytics,
    this.chatCrypto,
    this.poleEmploiTokenRepository,
    this.poleEmploiAuthRepository,
    this.userActionRepository,
    this.userActionPERepository,
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
    this.conseillerRepository,
    this.modeDemoRepository,
  );

  redux.Store<AppState> initializeReduxStore({required AppState initialState}) {
    return redux.Store<AppState>(
      reducer,
      initialState: initialState,
      middleware: [
        BootstrapMiddleware(),
        LoginMiddleware(authenticator, firebaseAuthWrapper, modeDemoRepository),
        PoleEmploiAuthMiddleware(poleEmploiAuthRepository, poleEmploiTokenRepository),
        UserActionListMiddleware(userActionRepository),
        UserActionCreateMiddleware(userActionRepository),
        UserActionUpdateMiddleware(userActionRepository),
        UserActionDeleteMiddleware(userActionRepository),
        UserActionPEListMiddleware(userActionPERepository),
        ConseillerMiddleware(conseillerRepository),
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
        ..._debugMiddleware(),
      ],
    );
  }

  List<redux.Middleware<AppState>> _debugMiddleware() {
    if (kReleaseMode) return [];
    return [ActionLoggingMiddleware()];
  }
}
