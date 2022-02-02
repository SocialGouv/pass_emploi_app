import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/store/store_factory.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/firebase_auth_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

import '../doubles/dummies.dart';

class TestStoreFactory {
  Authenticator authenticator = DummyAuthenticator();
  UserActionRepository userActionRepository = DummyUserActionRepository();
  RendezvousRepository rendezvousRepository = DummyRendezvousRepository();
  ChatRepository chatRepository = DummyChatRepository();
  OffreEmploiRepository offreEmploiRepository = DummyOffreEmploiRepository();
  OffreEmploiDetailsRepository detailedOfferRepository = DummyDetailedRepository();
  RegisterTokenRepository registerTokenRepository = DummyRegisterTokenRepository();
  Crashlytics crashlytics = DummyCrashlytics();
  OffreEmploiFavorisRepository offreEmploiFavorisRepository = DummyOffreEmploiFavorisRepository();
  SearchLocationRepository searchLocationRepository = DummySearchLocationRepository();
  ImmersionRepository immersionRepository = DummyImmersionRepository();
  ImmersionDetailsRepository immersionDetailsRepository = DummyImmersionDetailsRepository();
  ImmersionFavorisRepository immersionFavorisRepository = DummyImmersionFavorisRepository();
  FirebaseAuthRepository firebaseAuthRepository = DummyFirebaseAuthRepository();
  FirebaseAuthWrapper firebaseAuthWrapper = DummyFirebaseAuthWrapper();
  ChatCrypto chatCrypto = DummyChatCrypto();
  TrackingEventRepository trackingEventRepository = DummyTrackingEventRepository();

  Store<AppState> initializeReduxStore({required AppState initialState}) {
    return StoreFactory(
      authenticator,
      userActionRepository,
      rendezvousRepository,
      offreEmploiRepository,
      chatRepository,
      registerTokenRepository,
      crashlytics,
      detailedOfferRepository,
      offreEmploiFavorisRepository,
      immersionFavorisRepository,
      searchLocationRepository,
      immersionRepository,
      immersionDetailsRepository,
      firebaseAuthRepository,
      firebaseAuthWrapper,
      chatCrypto,
      trackingEventRepository,
    ).initializeReduxStore(initialState: initialState);
  }
}
