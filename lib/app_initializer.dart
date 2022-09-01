import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:matomo/matomo.dart';
import 'package:package_info/package_info.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/auth/auth_access_checker.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/configuration/app_version_checker.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_client.dart';
import 'package:pass_emploi_app/network/cache_interceptor.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/interceptors/access_token_interceptor.dart';
import 'package:pass_emploi_app/network/interceptors/logging_interceptor.dart';
import 'package:pass_emploi_app/network/interceptors/logout_interceptor.dart';
import 'package:pass_emploi_app/network/interceptors/monitoring_interceptor.dart';
import 'package:pass_emploi_app/pages/force_update_page.dart';
import 'package:pass_emploi_app/pass_emploi_app.dart';
import 'package:pass_emploi_app/push/firebase_push_notification_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/redux/store_factory.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';
import 'package:pass_emploi_app/repositories/auth/firebase_auth_repository.dart';
import 'package:pass_emploi_app/repositories/auth/logout_repository.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/repositories/rating_repository.dart';
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
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:pass_emploi_app/utils/secure_storage_exception_handler_decorator.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';
import 'package:redux/redux.dart';
import 'package:synchronized/synchronized.dart';

class AppInitializer {
  Future<Widget> initializeApp() async {
    await Firebase.initializeApp();
    await _initializeCrashlytics();
    final configuration = await Configuration.build();
    await _initializeMatomoTracker(configuration);
    final remoteConfig = await _remoteConfig();
    final forceUpdate = await _shouldForceUpdate(remoteConfig);
    if (forceUpdate) {
      return ForceUpdatePage(configuration.flavor);
    } else {
      final store = await _initializeReduxStore(configuration, remoteConfig);
      return PassEmploiApp(store);
    }
  }

  Future<void> _initializeCrashlytics() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  }

  Future<void> _initializeMatomoTracker(Configuration configuration) async {
    final siteId = configuration.matomoSiteId;
    final url = configuration.matomoBaseUrl;
    await MatomoTracker().initialize(siteId: int.parse(siteId), url: url);
    MatomoTracker.setCustomDimension(AnalyticsCustomDimensions.userTypeId, AnalyticsCustomDimensions.appUserType);
  }

  Future<FirebaseRemoteConfig?> _remoteConfig() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
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

  Future<bool> _shouldForceUpdate(FirebaseRemoteConfig? remoteConfig) async {
    if (remoteConfig == null) return false;
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final minimumVersionKey = Platform.isAndroid ? 'app_android_min_required_version' : 'app_ios_min_required_version';
    final currentVersion = packageInfo.version;
    final minimumVersion = remoteConfig.getString(minimumVersionKey);
    return AppVersionChecker().shouldForceUpdate(currentVersion: currentVersion, minimumVersion: minimumVersion);
  }

  Future<Store<AppState>> _initializeReduxStore(Configuration configuration, FirebaseRemoteConfig? remoteConfig) async {
    final crashlytics = CrashlyticsWithFirebase(FirebaseCrashlytics.instance);
    final pushNotificationManager = FirebasePushNotificationManager();
    final securedPreferences = SecureStorageExceptionHandlerDecorator(
      FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true)),
    );
    final logoutRepository = LogoutRepository(
      configuration.authIssuer,
      configuration.authClientSecret,
      configuration.authClientId,
      crashlytics,
    );
    final authenticator = Authenticator(
      AuthWrapper(FlutterAppAuth(), Lock()),
      logoutRepository,
      configuration,
      securedPreferences,
      crashlytics,
    );
    final accessTokenRetriever = AuthAccessTokenRetriever(authenticator);
    final authAccessChecker = AuthAccessChecker();
    final defaultContext = SecurityContext.defaultContext;
    final modeDemoRepository = ModeDemoRepository();
    try {
      defaultContext.setTrustedCertificatesBytes(utf8.encode(configuration.iSRGX1CertificateForOldDevices));
    } catch (e, stack) {
      crashlytics.recordNonNetworkException(e, stack);
    }
    final Client clientWithCertificate = IOClient(HttpClient(context: defaultContext));
    final requestCacheManager = PassEmploiCacheManager.requestCache();
    final monitoringInterceptor = MonitoringInterceptor(InstallationIdRepository(securedPreferences));
    final modeDemoClient = ModeDemoClient(
      modeDemoRepository,
      HttpClientWithCache(requestCacheManager, clientWithCertificate),
    );
    final httpClient = InterceptedClient.build(
      client: modeDemoClient,
      interceptors: [
        monitoringInterceptor,
        AccessTokenInterceptor(accessTokenRetriever, modeDemoRepository),
        LogoutInterceptor(authAccessChecker),
        LoggingInterceptor(),
      ],
    );
    logoutRepository.setHttpClient(httpClient);
    logoutRepository.setCacheManager(requestCacheManager);
    final chatCrypto = ChatCrypto();
    final baseUrl = configuration.serverBaseUrl;
    final reduxStore = StoreFactory(
      authenticator,
      crashlytics,
      chatCrypto,
      PageActionRepository(baseUrl, httpClient, crashlytics),
      PageDemarcheRepository(baseUrl, httpClient, crashlytics),
      RendezvousRepository(baseUrl, httpClient, crashlytics),
      OffreEmploiRepository(baseUrl, httpClient, crashlytics),
      ChatRepository(chatCrypto, crashlytics, modeDemoRepository),
      RegisterTokenRepository(baseUrl, httpClient, pushNotificationManager, crashlytics),
      OffreEmploiDetailsRepository(baseUrl, httpClient, crashlytics),
      OffreEmploiFavorisRepository(baseUrl, httpClient, requestCacheManager, crashlytics),
      ImmersionFavorisRepository(baseUrl, httpClient, requestCacheManager, crashlytics),
      ServiceCiviqueFavorisRepository(baseUrl, httpClient, requestCacheManager, crashlytics),
      SearchLocationRepository(baseUrl, httpClient, crashlytics),
      MetierRepository(),
      ImmersionRepository(baseUrl, httpClient, crashlytics),
      ImmersionDetailsRepository(baseUrl, httpClient, crashlytics),
      FirebaseAuthRepository(baseUrl, httpClient, crashlytics),
      FirebaseAuthWrapper(),
      TrackingEventRepository(baseUrl, httpClient, crashlytics),
      OffreEmploiSavedSearchRepository(baseUrl, httpClient, requestCacheManager, crashlytics),
      ImmersionSavedSearchRepository(baseUrl, httpClient, requestCacheManager, crashlytics),
      ServiceCiviqueSavedSearchRepository(baseUrl, httpClient, requestCacheManager, crashlytics),
      GetSavedSearchRepository(baseUrl, httpClient, crashlytics),
      SavedSearchDeleteRepository(baseUrl, httpClient, requestCacheManager, crashlytics),
      ServiceCiviqueRepository(baseUrl, httpClient, crashlytics),
      ServiceCiviqueDetailRepository(baseUrl, httpClient, crashlytics),
      DetailsJeuneRepository(baseUrl, httpClient, crashlytics),
      SuppressionCompteRepository(baseUrl, httpClient, crashlytics),
      modeDemoRepository,
      CampagneRepository(baseUrl, httpClient, crashlytics),
      MatomoTracker(),
      remoteConfig,
      UpdateDemarcheRepository(baseUrl, httpClient, crashlytics),
      CreateDemarcheRepository(baseUrl, httpClient, crashlytics),
      SearchDemarcheRepository(baseUrl, httpClient, crashlytics),
      PieceJointeRepository(baseUrl, httpClient, crashlytics),
      TutorialRepository(securedPreferences),
      PartageActiviteRepository(baseUrl, httpClient, requestCacheManager, crashlytics),
      RatingRepository(securedPreferences),
      ActionCommentaireRepository(baseUrl, httpClient, requestCacheManager, crashlytics),
      AgendaRepository(baseUrl, httpClient, crashlytics),
    ).initializeReduxStore(initialState: AppState.initialState(configuration: configuration));
    accessTokenRetriever.setStore(reduxStore);
    authAccessChecker.setStore(reduxStore);
    monitoringInterceptor.setStore(reduxStore);
    chatCrypto.setStore(reduxStore);
    await pushNotificationManager.init(reduxStore);
    return reduxStore;
  }
}
