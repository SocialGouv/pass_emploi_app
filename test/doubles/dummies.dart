import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/auth/firebase_auth_repository.dart';
import 'package:pass_emploi_app/repositories/auth/logout_repository.dart';
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
import 'package:synchronized/synchronized.dart';

import 'dummies_for_cache.dart';
import 'fixtures.dart';
import 'spies.dart';

class DummyHeadersBuilder extends HeadersBuilder {}

class DummyPoleEmploiTokenRepository extends PoleEmploiTokenRepository {}

class DummyHttpClient extends MockClient {
  DummyHttpClient() : super((request) async => Response("", 200));
}

class DummyPushNotificationManager extends PushNotificationManager {
  @override
  Future<String?> getToken() async => "";

  @override
  Future<void> init(Store<AppState> store) async {}
}

class DummyRegisterTokenRepository extends RegisterTokenRepository {
  DummyRegisterTokenRepository() : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPushNotificationManager());

  @override
  Future<void> registerToken(String userId) async {}
}

class DummyAuthenticator extends Authenticator {
  DummyAuthenticator() : super(DummyAuthWrapper(), DummyLogoutRepository(), configuration(), SharedPreferencesSpy());
}

class DummyAuthWrapper extends AuthWrapper {
  DummyAuthWrapper() : super(DummyFlutterAppAuth(), Lock());
}

class DummyFlutterAppAuth extends FlutterAppAuth {}

class DummyUserActionRepository extends UserActionRepository {
  DummyUserActionRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyUserActionPERepository extends UserActionPERepository {
  DummyUserActionPERepository() : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPoleEmploiTokenRepository());
}

class DummyPoleEmploiAuthRepository extends PoleEmploiAuthRepository {
  DummyPoleEmploiAuthRepository() : super("", DummyHttpClient());
}

class DummyRendezvousRepository extends RendezvousRepository {
  DummyRendezvousRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyChatRepository extends ChatRepository {
  DummyChatRepository() : super(DummyChatCrypto(), DummyCrashlytics(), ModeDemoRepository());

  @override
  Stream<List<Message>> messagesStream(String userId) async* {}

  @override
  Stream<ConseillerMessageInfo> chatStatusStream(String userId) async* {}
}

class DummyCrashlytics extends Crashlytics {
  @override
  void setCustomKey(String key, value) {}

  @override
  void recordNonNetworkException(dynamic exception, StackTrace stack, [Uri? failingEndpoint]) {}
}

class DummyOffreEmploiRepository extends OffreEmploiRepository {
  DummyOffreEmploiRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyDetailedRepository extends OffreEmploiDetailsRepository {
  DummyDetailedRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyOffreEmploiFavorisRepository extends OffreEmploiFavorisRepository {
  DummyOffreEmploiFavorisRepository()
      : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPassEmploiCacheManager());
}

class DummySearchLocationRepository extends SearchLocationRepository {
  DummySearchLocationRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyFirebaseAuthRepository extends FirebaseAuthRepository {
  DummyFirebaseAuthRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyFirebaseAuthWrapper extends FirebaseAuthWrapper {
  @override
  Future<bool> signInWithCustomToken(String token) async {
    return true;
  }

  @override
  Future<void> signOut() async {
    return;
  }
}

class DummyImmersionRepository extends ImmersionRepository {
  DummyImmersionRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyImmersionDetailsRepository extends ImmersionDetailsRepository {
  DummyImmersionDetailsRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyChatCrypto extends ChatCrypto {
  DummyChatCrypto() : super();
}

class DummyTrackingEventRepository extends TrackingEventRepository {
  DummyTrackingEventRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyImmersionFavorisRepository extends ImmersionFavorisRepository {
  DummyImmersionFavorisRepository()
      : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPassEmploiCacheManager());
}

class DummyOffreEmploiSavedSearchRepository extends OffreEmploiSavedSearchRepository {
  DummyOffreEmploiSavedSearchRepository()
      : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPassEmploiCacheManager());
}

class DummyImmersionSavedSearchRepository extends ImmersionSavedSearchRepository {
  DummyImmersionSavedSearchRepository()
      : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPassEmploiCacheManager());
}

class DummyServiceCiviqueSavedSearchRepository extends ServiceCiviqueSavedSearchRepository {
  DummyServiceCiviqueSavedSearchRepository()
      : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPassEmploiCacheManager());
}

class DummyGetSavedSearchRepository extends GetSavedSearchRepository {
  DummyGetSavedSearchRepository() : super("", DummyHttpClient(), DummyHeadersBuilder(), null);
}

class DummySavedSearchDeleteRepository extends SavedSearchDeleteRepository {
  DummySavedSearchDeleteRepository()
      : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPassEmploiCacheManager());
}

class DummyServiceCiviqueRepository extends ServiceCiviqueRepository {
  DummyServiceCiviqueRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyServiceCiviqueDetailRepository extends ServiceCiviqueDetailRepository {
  DummyServiceCiviqueDetailRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyServiceCiviqueFavorisRepository extends ServiceCiviqueFavorisRepository {
  DummyServiceCiviqueFavorisRepository()
      : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPassEmploiCacheManager());
}

class DummyConseillerRepository extends ConseillerRepository {
  DummyConseillerRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyLogoutRepository extends LogoutRepository {
  DummyLogoutRepository() : super('', '', '');
}

class DummyPassEmploiCacheManager extends PassEmploiCacheManager {
  DummyPassEmploiCacheManager() : super(DummyConfig());

  @override
  void removeRessource(CachedRessource ressourceToRemove, String userId, String baseUrl) {}
}
