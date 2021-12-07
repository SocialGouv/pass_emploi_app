import 'package:flutter/foundation.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/redux/middlewares/action_logging_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/api_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/chat_subscription_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/crashlytics_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/offre_emploi_details_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/offre_emploi_favoris_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/offre_emploi_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/register_push_notification_token_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/rendezvous_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/router_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/user_action_middleware.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';
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
  );

  Store<AppState> initializeReduxStore({required AppState initialState}) {
    return Store<AppState>(
      reducer,
      initialState: initialState,
      middleware: [
        RouterMiddleware(authenticator),
        ApiMiddleware(userActionRepository, chatRepository),
        UserActionMiddleware(userActionRepository),
        RendezvousMiddleware(rendezvousRepository),
        RegisterPushNotificationTokenMiddleware(registerTokenRepository),
        OffreEmploiMiddleware(offreEmploiRepository),
        OffreEmploiDetailsMiddleware(offreEmploiDetailsRepository),
        OffreEmploiFavorisMiddleware(offreEmploiFavorisRepository),
        RegisterPushNotificationTokenMiddleware(registerTokenRepository),
        ChatSubscriptionMiddleware(chatRepository),
        CrashlyticsMiddleware(crashlytics),
        ..._debugMiddleware(),
      ],
    );
  }

  List<Middleware<AppState>> _debugMiddleware() {
    if (kReleaseMode) {
      return [];
    }
    return [
      ActionLoggingMiddleware(),
    ];
  }
}
