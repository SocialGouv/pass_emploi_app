import 'package:flutter/foundation.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/redux/middlewares/action_logging_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/animation_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/api_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/crashlytics_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/detailed_offer_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/offre_emploi_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/register_push_notification_token_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/rendezvous_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/router_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/user_action_middleware.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/detailed_offer_repository.dart';
import 'package:pass_emploi_app/repositories/home_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

class StoreFactory {
  final UserRepository userRepository;
  final HomeRepository homeRepository;
  final UserActionRepository userActionRepository;
  final RendezvousRepository rendezvousRepository;
  final OffreEmploiRepository offreEmploiRepository;
  final ChatRepository chatRepository;
  final RegisterTokenRepository registerTokenRepository;
  final Crashlytics crashlytics;
  final DetailedOfferRepository detailedOfferRepository;

  StoreFactory(
    this.userRepository,
    this.homeRepository,
    this.userActionRepository,
    this.rendezvousRepository,
    this.offreEmploiRepository,
    this.chatRepository,
    this.registerTokenRepository,
    this.crashlytics,
    this.detailedOfferRepository,
  );

  Store<AppState> initializeReduxStore({required AppState initialState}) {
    return Store<AppState>(
      reducer,
      initialState: initialState,
      middleware: [
        RouterMiddleware(userRepository),
        ApiMiddleware(
          userRepository,
          homeRepository,
          userActionRepository,
          chatRepository,
        ),
        UserActionMiddleware(userActionRepository),
        RendezvousMiddleware(rendezvousRepository),
        RegisterPushNotificationTokenMiddleware(registerTokenRepository),
        OffreEmploiMiddleware(offreEmploiRepository),
        DetailedOfferMiddleware(detailedOfferRepository),
        RegisterPushNotificationTokenMiddleware(
          registerTokenRepository,
        ),
        AnimationMiddleware(),
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
