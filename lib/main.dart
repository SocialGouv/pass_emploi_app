import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:matomo/matomo.dart';
import 'package:package_info/package_info.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/network/access_token_interceptor.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/logging_interceptor.dart';
import 'package:pass_emploi_app/pages/force_update_page.dart';
import 'package:pass_emploi_app/pass_emploi_app.dart';
import 'package:pass_emploi_app/push/firebase_push_notification_manager.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/store/store_factory.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configuration/app_version_checker.dart';
import 'configuration/configuration.dart';
import 'crashlytics/crashlytics.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  final configuration = await Configuration.build();
  await _initializeMatomoTracker(configuration);
  final remoteConfig = await _remoteConfig();
  final forceUpdate = await _shouldForceUpdate(remoteConfig);
  final PushNotificationManager pushManager = FirebasePushNotificationManager();
  final store = await _initializeReduxStore(configuration, pushManager);

  await pushManager.init(store);

  runZonedGuarded<Future<void>>(() async {
    runApp(forceUpdate ? ForceUpdatePage() : PassEmploiApp(store));
  }, FirebaseCrashlytics.instance.recordError);

  await _handleErrorsOutsideFlutter();
}

Future<void> _initializeMatomoTracker(Configuration configuration) async {
  final siteId = configuration.matomoSiteId;
  final url = configuration.matomoBaseUrl;
  await MatomoTracker().initialize(siteId: int.parse(siteId), url: url);
}

Future<RemoteConfig?> _remoteConfig() async {
  final RemoteConfig remoteConfig = RemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: Duration(seconds: 5),
    minimumFetchInterval: Duration(minutes: 5),
  ));
  try {
    await remoteConfig.fetchAndActivate();
  } catch (e) {
    return null;
  }
  return remoteConfig;
}

Future<bool> _shouldForceUpdate(RemoteConfig? remoteConfig) async {
  if (remoteConfig == null) return false;
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final minimumVersionKey = Platform.isAndroid ? 'app_android_min_required_version' : 'app_ios_min_required_version';
  final currentVersion = packageInfo.version;
  final minimumVersion = remoteConfig.getString(minimumVersionKey);
  return AppVersionChecker().shouldForceUpdate(currentVersion: currentVersion, minimumVersion: minimumVersion);
}

Future<Store<AppState>> _initializeReduxStore(
  Configuration configuration,
  PushNotificationManager pushNotificationManager,
) async {
  final headersBuilder = HeadersBuilder();
  final preferences = await SharedPreferences.getInstance();
  final authenticator = Authenticator(AuthWrapper(FlutterAppAuth()), configuration, preferences);
  final accessTokenRetriever = AuthAccessTokenRetriever(authenticator);
  final httpClient = InterceptedClient.build(
    interceptors: [AccessTokenInterceptor(accessTokenRetriever), LoggingInterceptor()],
  );
  final reduxStore = StoreFactory(
    authenticator,
    UserRepository(configuration.serverBaseUrl, httpClient, headersBuilder),
    UserActionRepository(configuration.serverBaseUrl, httpClient, headersBuilder),
    RendezvousRepository(configuration.serverBaseUrl, httpClient, headersBuilder),
    OffreEmploiRepository(configuration.serverBaseUrl, httpClient, headersBuilder),
    ChatRepository(configuration.firebaseEnvironmentPrefix),
    RegisterTokenRepository(
      configuration.serverBaseUrl,
      httpClient,
      headersBuilder,
      pushNotificationManager,
    ),
    CrashlyticsWithFirebase(FirebaseCrashlytics.instance),
    OffreEmploiDetailsRepository(configuration.serverBaseUrl, httpClient, headersBuilder),
    OffreEmploiFavorisRepository(configuration.serverBaseUrl, httpClient, headersBuilder),
  ).initializeReduxStore(initialState: AppState.initialState());
  accessTokenRetriever.setStore(reduxStore);
  return reduxStore;
}

Future _handleErrorsOutsideFlutter() async {
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);
}
