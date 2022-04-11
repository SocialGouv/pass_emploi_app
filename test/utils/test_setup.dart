import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/redux/store_factory.dart';
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
import 'package:redux/redux.dart';

import '../doubles/dummies.dart';

class TestStoreFactory {
  Authenticator authenticator = DummyAuthenticator();
  PoleEmploiTokenRepository poleEmploiTokenRepository = PoleEmploiTokenRepository();
  PoleEmploiAuthRepository poleEmploiAuthRepository = DummyPoleEmploiAuthRepository();
  UserActionRepository userActionRepository = DummyUserActionRepository();
  UserActionPERepository userActionPERepository = DummyUserActionPERepository();
  RendezvousRepository rendezvousRepository = DummyRendezvousRepository();
  ChatRepository chatRepository = DummyChatRepository();
  OffreEmploiRepository offreEmploiRepository = DummyOffreEmploiRepository();
  OffreEmploiDetailsRepository detailedOfferRepository = DummyDetailedRepository();
  RegisterTokenRepository registerTokenRepository = DummyRegisterTokenRepository();
  Crashlytics crashlytics = DummyCrashlytics();
  OffreEmploiFavorisRepository offreEmploiFavorisRepository = DummyOffreEmploiFavorisRepository();
  SearchLocationRepository searchLocationRepository = DummySearchLocationRepository();
  MetierRepository metierRepository = MetierRepository();
  ImmersionRepository immersionRepository = DummyImmersionRepository();
  ImmersionDetailsRepository immersionDetailsRepository = DummyImmersionDetailsRepository();
  ImmersionFavorisRepository immersionFavorisRepository = DummyImmersionFavorisRepository();
  FirebaseAuthRepository firebaseAuthRepository = DummyFirebaseAuthRepository();
  FirebaseAuthWrapper firebaseAuthWrapper = DummyFirebaseAuthWrapper();
  ChatCrypto chatCrypto = DummyChatCrypto();
  TrackingEventRepository trackingEventRepository = DummyTrackingEventRepository();
  OffreEmploiSavedSearchRepository offreEmploiSavedSearchRepository = DummyOffreEmploiSavedSearchRepository();
  ImmersionSavedSearchRepository immersionSavedSearchRepository = DummyImmersionSavedSearchRepository();
  ServiceCiviqueSavedSearchRepository serviceCiviqueSavedSearchRepository = DummyServiceCiviqueSavedSearchRepository();
  GetSavedSearchRepository getSavedSearchRepository = DummyGetSavedSearchRepository();
  SavedSearchDeleteRepository savedSearchDeleteRepository = DummySavedSearchDeleteRepository();
  ServiceCiviqueRepository serviceCiviqueRepository = DummyServiceCiviqueRepository();
  ServiceCiviqueDetailRepository serviceCiviqueDetailRepository = DummyServiceCiviqueDetailRepository();
  ServiceCiviqueFavorisRepository serviceCiviqueFavorisRepository = DummyServiceCiviqueFavorisRepository();
  ConseillerRepository conseillerRepository = DummyConseillerRepository();
  ModeDemoRepository demoRepository = ModeDemoRepository();

  Store<AppState> initializeReduxStore({required AppState initialState}) {
    return StoreFactory(
      authenticator,
      crashlytics,
      chatCrypto,
      poleEmploiTokenRepository,
      poleEmploiAuthRepository,
      userActionRepository,
      userActionPERepository,
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
      firebaseAuthRepository,
      firebaseAuthWrapper,
      trackingEventRepository,
      offreEmploiSavedSearchRepository,
      immersionSavedSearchRepository,
      serviceCiviqueSavedSearchRepository,
      getSavedSearchRepository,
      savedSearchDeleteRepository,
      serviceCiviqueRepository,
      serviceCiviqueDetailRepository,
      conseillerRepository,
      demoRepository,
    ).initializeReduxStore(initialState: initialState);
  }
}
