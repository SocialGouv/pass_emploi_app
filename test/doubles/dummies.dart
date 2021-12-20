import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/firebase_auth_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

import 'fixtures.dart';
import 'spies.dart';

class DummyHeadersBuilder extends HeadersBuilder {}

class DummyHttpClient extends MockClient {
  DummyHttpClient() : super((request) async => Response("", 200));
}

class DummyPushNotificationManager extends PushNotificationManager {
  @override
  Future<String?> getToken() async {
    return "";
  }

  @override
  Future<void> init(Store<AppState> store) async {}
}

class DummyRegisterTokenRepository extends RegisterTokenRepository {
  DummyRegisterTokenRepository() : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPushNotificationManager());

  Future<void> registerToken(String userId) async {}
}

class DummyAuthenticator extends Authenticator {
  DummyAuthenticator() : super(DummyAuthWrapper(), configuration(), SharedPreferencesSpy());
}

class DummyAuthWrapper extends AuthWrapper {
  DummyAuthWrapper() : super(DummyFlutterAppAuth());
}

class DummyFlutterAppAuth extends FlutterAppAuth {}

class DummyUserActionRepository extends UserActionRepository {
  DummyUserActionRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyRendezvousRepository extends RendezvousRepository {
  DummyRendezvousRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyChatRepository extends ChatRepository {
  DummyChatRepository() : super("");
}

class DummyCrashlytics extends Crashlytics {
  @override
  void setCustomKey(String key, value) {}
}

class DummyOffreEmploiRepository extends OffreEmploiRepository {
  DummyOffreEmploiRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyDetailedRepository extends OffreEmploiDetailsRepository {
  DummyDetailedRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyOffreEmploiFavorisRepository extends OffreEmploiFavorisRepository {
  DummyOffreEmploiFavorisRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummySearchLocationRepository extends SearchLocationRepository {
  DummySearchLocationRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyFirebaseAuthRepository extends FirebaseAuthRepository {
  DummyFirebaseAuthRepository() : super("", DummyHttpClient(), DummyHeadersBuilder());
}

class DummyFirebaseAuthWrapper extends FirebaseAuthWrapper {}
