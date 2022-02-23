import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:async_redux/async_redux.dart' as async_redux;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:matomo/matomo.dart';
import 'package:package_info/package_info.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/network/access_token_interceptor.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/pages/force_update_page.dart';
import 'package:pass_emploi_app/pass_emploi_app.dart';
import 'package:pass_emploi_app/push/firebase_push_notification_manager.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/store/store_factory_v1.dart';
import 'package:pass_emploi_app/redux/store/store_factory_v2.dart';
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
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

import 'analytics/analytics_constants.dart';
import 'configuration/app_version_checker.dart';
import 'configuration/configuration.dart';
import 'crashlytics/crashlytics.dart';
import 'network/logging_interceptor.dart';

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
  final initialState = AppState.initialState(configuration: configuration);
  final storeV1 = await _initializeReduxStoreV1(configuration, pushManager, initialState);
  final storeV2 = await _initializeReduxStoreV2(configuration, initialState, storeV1);

  await pushManager.init(storeV1);

  runZonedGuarded<Future<void>>(() async {
    runApp(forceUpdate ? ForceUpdatePage(configuration.flavor) : PassEmploiApp(storeV1: storeV1, storeV2: storeV2));
  }, FirebaseCrashlytics.instance.recordError);

  await _handleErrorsOutsideFlutter();
}

Future<void> _initializeMatomoTracker(Configuration configuration) async {
  final siteId = configuration.matomoSiteId;
  final url = configuration.matomoBaseUrl;
  await MatomoTracker().initialize(siteId: int.parse(siteId), url: url);
  MatomoTracker.setCustomDimension(AnalyticsCustomDimensions.userTypeId, AnalyticsCustomDimensions.appUserType);
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

Future<Store<AppState>> _initializeReduxStoreV1(
  Configuration configuration,
  PushNotificationManager pushNotificationManager,
  AppState initialState,
) async {
  final headersBuilder = HeadersBuilder();
  final securedPreferences = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
  final authenticator = Authenticator(AuthWrapper(FlutterAppAuth()), configuration, securedPreferences);
  final accessTokenRetriever = AuthAccessTokenRetriever(authenticator);
  final crashlytics = CrashlyticsWithFirebase(FirebaseCrashlytics.instance);
  var defaultContext = SecurityContext.defaultContext;
  try {
    defaultContext.setTrustedCertificatesBytes(utf8.encode(configuration.iSRGX1CertificateForOldDevices));
  } catch (e, stack) {
    crashlytics.recordNonNetworkException(e, stack);
  }
  Client clientWithCertificate = IOClient(HttpClient(context: defaultContext));
  final httpClient = InterceptedClient.build(
    client: clientWithCertificate,
    interceptors: [AccessTokenInterceptor(accessTokenRetriever), LoggingInterceptor()],
  );
  final chatCrypto = ChatCrypto();
  final reduxStore = StoreFactoryV1(
    authenticator,
    UserActionRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    RendezvousRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    OffreEmploiRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    ChatRepository(chatCrypto, crashlytics),
    RegisterTokenRepository(
      configuration.serverBaseUrl,
      httpClient,
      headersBuilder,
      pushNotificationManager,
      crashlytics,
    ),
    crashlytics,
    OffreEmploiDetailsRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    OffreEmploiFavorisRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    ImmersionFavorisRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    SearchLocationRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    MetierRepository(),
    ImmersionRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    ImmersionDetailsRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    FirebaseAuthRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    FirebaseAuthWrapper(),
    chatCrypto,
    TrackingEventRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    OffreEmploiSavedSearchRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    ImmersionSavedSearchRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
    GetSavedSearchRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
  ).initializeReduxStore(initialState: initialState);
  accessTokenRetriever.setStore(reduxStore);
  return reduxStore;
}

Future<async_redux.Store<AppState>> _initializeReduxStoreV2(
  Configuration configuration,
  AppState initialState,
  Store<AppState> storeV1,
) async {
  final headersBuilder = HeadersBuilder();
  final securedPreferences = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
  final authenticator = Authenticator(AuthWrapper(FlutterAppAuth()), configuration, securedPreferences);
  final accessTokenRetriever = AuthAccessTokenRetriever(authenticator);
  final crashlytics = CrashlyticsWithFirebase(FirebaseCrashlytics.instance);
  var defaultContext = SecurityContext.defaultContext;
  try {
    defaultContext.setTrustedCertificatesBytes(utf8.encode(configuration.iSRGX1CertificateForOldDevices));
  } catch (e, stack) {
    crashlytics.recordNonNetworkException(e, stack);
  }
  Client clientWithCertificate = IOClient(HttpClient(context: defaultContext));
  final httpClient = InterceptedClient.build(
    client: clientWithCertificate,
    interceptors: [AccessTokenInterceptor(accessTokenRetriever), LoggingInterceptor()],
  );
  return StoreFactoryV2(
    SavedSearchDeleteRepository(configuration.serverBaseUrl, httpClient, headersBuilder, crashlytics),
  ).initializeReduxStoreV2(initialState: initialState, storeV1: storeV1);
}

Future<void> _handleErrorsOutsideFlutter() async {
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final errorAndStacktrace = pair as List<dynamic>;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last as StackTrace,
    );
  }).sendPort);
}
