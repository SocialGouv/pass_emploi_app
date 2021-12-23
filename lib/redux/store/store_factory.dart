import 'package:flutter/foundation.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/middlewares/action_logging_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/chat_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/crashlytics_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/login_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/offre_emploi_details_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/offre_emploi_favoris_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/offre_emploi_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/pass_emploi_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/register_push_notification_token_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/search_location_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/user_action_middleware.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';
import 'package:pass_emploi_app/redux/requests/rendezvous_request.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/firebase_auth_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

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
  final SearchLocationRepository searchLocationRepository;
  final ImmersionRepository immersionRepository;
  final FirebaseAuthRepository firebaseAuthRepository;
  final FirebaseAuthWrapper firebaseAuthWrapper;

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
    this.searchLocationRepository,
    this.immersionRepository,
    this.firebaseAuthRepository,
    this.firebaseAuthWrapper,
  );

  Store<AppState> initializeReduxStore({required AppState initialState}) {
    return Store<AppState>(
      reducer,
      initialState: initialState,
      middleware: [
        LoginMiddleware(authenticator, firebaseAuthRepository, firebaseAuthWrapper),
        ChatMiddleware(chatRepository),
        UserActionMiddleware(userActionRepository),
        RegisterPushNotificationTokenMiddleware(registerTokenRepository),
        OffreEmploiMiddleware(offreEmploiRepository),
        OffreEmploiDetailsMiddleware(offreEmploiDetailsRepository),
        OffreEmploiFavorisMiddleware(offreEmploiFavorisRepository),
        RegisterPushNotificationTokenMiddleware(registerTokenRepository),
        CrashlyticsMiddleware(crashlytics),
        SearchLocationMiddleware(searchLocationRepository),
        PassEmploiMiddleware<RendezvousRequest, List<Rendezvous>>(rendezvousRepository),
        PassEmploiMiddleware<ImmersionRequest, List<Immersion>>(immersionRepository),
        ..._debugMiddleware(),
      ],
    );
  }

  List<Middleware<AppState>> _debugMiddleware() {
    if (kReleaseMode) return [];
    return [ActionLoggingMiddleware()];
  }
}
