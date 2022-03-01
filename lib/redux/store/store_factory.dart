import 'package:flutter/foundation.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/chat/init/chat_initializer_middleware.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_middleware.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_middleware.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_middleware.dart';
import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_middleware.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_middleware.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_middleware.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_middleware.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_middleware.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/middlewares/action_logging_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/crashlytics_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/data_from_id_extractor.dart';
import 'package:pass_emploi_app/redux/middlewares/favoris_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/immersion_details_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/login_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/offre_emploi_details_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/offre_emploi_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/offre_emploi_saved_search_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/register_push_notification_token_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/search_location_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/search_metier_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/tracking_event_middleware.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/firebase_auth_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searchs_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/immersion_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/offre_emploi_saved_search_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_delete_repository.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart' as redux;

import '../../features/service_civique/detail/service_civique_detail_middleware.dart';
import '../../repositories/service_civique/service_civique_repository.dart';
import '../middlewares/immersion_saved_search_middleware.dart';
import '../middlewares/initialize_saved_search_middleware.dart';
import '../middlewares/saved_search/saved_search_middleware.dart';
import '../middlewares/saved_search/saved_searchs_list_request_middleware.dart';
import '../middlewares/user_tracking_structure_middleware.dart';

class StoreFactory {
  final Authenticator authenticator;
  final UserActionRepository userActionRepository;
  final RendezvousRepository rendezvousRepository;
  final OffreEmploiRepository offreEmploiRepository;
  final ChatRepository chatRepository;
  final RegisterTokenRepository registerTokenRepository;
  final Crashlytics crashlytics;
  final OffreEmploiDetailsRepository offreEmploiDetailsRepository;
  final OffreEmploiFavorisRepository offreEmploiFavorisRepository;
  final ImmersionFavorisRepository immersionFavorisRepository;
  final SearchLocationRepository searchLocationRepository;
  final MetierRepository metierRepository;
  final ImmersionRepository immersionRepository;
  final ImmersionDetailsRepository immersionDetailsRepository;
  final FirebaseAuthRepository firebaseAuthRepository;
  final FirebaseAuthWrapper firebaseAuthWrapper;
  final ChatCrypto chatCrypto;
  final TrackingEventRepository trackingEventRepository;
  final OffreEmploiSavedSearchRepository offreEmploiSavedSearchRepository;
  final ImmersionSavedSearchRepository immersionSavedSearchRepository;
  final GetSavedSearchRepository getSavedSearchRepository;
  final SavedSearchDeleteRepository savedSearchDeleteRepository;
  final ServiceCiviqueRepository serviceCiviqueRepository;
  final ServiceCiviqueDetailRepository serviceCiviqueDetailRepository;

  StoreFactory(
    this.authenticator,
    this.userActionRepository,
    this.rendezvousRepository,
    this.offreEmploiRepository,
    this.chatRepository,
    this.registerTokenRepository,
    this.crashlytics,
    this.offreEmploiDetailsRepository,
    this.offreEmploiFavorisRepository,
    this.immersionFavorisRepository,
    this.searchLocationRepository,
    this.metierRepository,
    this.immersionRepository,
    this.immersionDetailsRepository,
    this.firebaseAuthRepository,
    this.firebaseAuthWrapper,
    this.chatCrypto,
    this.trackingEventRepository,
    this.offreEmploiSavedSearchRepository,
    this.immersionSavedSearchRepository,
    this.getSavedSearchRepository,
    this.savedSearchDeleteRepository,
    this.serviceCiviqueRepository,
    this.serviceCiviqueDetailRepository,
  );

  redux.Store<AppState> initializeReduxStore({required AppState initialState}) {
    return redux.Store<AppState>(
      reducer,
      initialState: initialState,
      middleware: [
        LoginMiddleware(authenticator, firebaseAuthWrapper),
        UserActionListMiddleware(userActionRepository),
        UserActionCreateMiddleware(userActionRepository),
        UserActionUpdateMiddleware(userActionRepository),
        UserActionDeleteMiddleware(userActionRepository),
        ChatInitializerMiddleware(firebaseAuthRepository, firebaseAuthWrapper, chatCrypto),
        ChatMiddleware(chatRepository),
        ChatStatusMiddleware(chatRepository),
        RegisterPushNotificationTokenMiddleware(registerTokenRepository),
        OffreEmploiMiddleware(offreEmploiRepository),
        OffreEmploiDetailsMiddleware(offreEmploiDetailsRepository),
        FavorisMiddleware<OffreEmploi>(offreEmploiFavorisRepository, OffreEmploiDataFromIdExtractor()),
        FavorisMiddleware<Immersion>(immersionFavorisRepository, ImmersionDataFromIdExtractor()),
        RegisterPushNotificationTokenMiddleware(registerTokenRepository),
        CrashlyticsMiddleware(crashlytics),
        SearchLocationMiddleware(searchLocationRepository),
        SearchMetierMiddleware(metierRepository),
        TrackingEventMiddleware(trackingEventRepository),
        UserTrackingStructureMiddleware(),
        Middleware<void, List<Rendezvous>>(rendezvousRepository),
        Middleware<ImmersionRequest, List<Immersion>>(immersionRepository),
        ImmersionDetailsMiddleware(immersionDetailsRepository),
        OffreEmploiSavedSearchMiddleware(offreEmploiSavedSearchRepository),
        ImmersionSavedSearchMiddleware(immersionSavedSearchRepository),
        InitializeSavedSearchMiddleware(),
        SavedSearchListRequestMiddleware(getSavedSearchRepository),
        GetSavedSearchMiddleware(getSavedSearchRepository),
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
