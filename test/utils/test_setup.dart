import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/store/store_factory.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

import '../doubles/dummies.dart';

class TestStoreFactory {
  Authenticator authenticator = DummyAuthenticator();
  UserActionRepository userActionRepository = DummyUserActionRepository();
  RendezvousRepository rendezvousRepository = DummyRendezvousRepository();
  ChatRepository chatRepository = DummyChatRepository('firebaseEnvironmentPrefix');
  OffreEmploiRepository offreEmploiRepository = DummyOffreEmploiRepository();
  OffreEmploiDetailsRepository detailedOfferRepository = DummyDetailedRepository();
  RegisterTokenRepository registerTokenRepository = DummyRegisterTokenRepository();
  Crashlytics crashlytics = DummyCrashlytics();
  OffreEmploiFavorisRepository offreEmploiFavorisRepository = DummyOffreEmploiFavorisRepository();

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
    ).initializeReduxStore(initialState: initialState);
  }
}
