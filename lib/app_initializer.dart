import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pass_emploi_app/auth/auth_access_checker.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/configuration/app_version_checker.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/interceptors/monitoring_interceptor.dart';
import 'package:pass_emploi_app/network/pass_emploi_dio_builder.dart';
import 'package:pass_emploi_app/pages/force_update_page.dart';
import 'package:pass_emploi_app/pass_emploi_app.dart';
import 'package:pass_emploi_app/push/firebase_push_notification_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/redux/store_factory.dart';
import 'package:pass_emploi_app/remote_config/campagne_recrutement_config.dart';
import 'package:pass_emploi_app/remote_config/max_living_time_config.dart';
import 'package:pass_emploi_app/repositories/accueil_repository.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_delete_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/get_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/immersion_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/offre_emploi_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/alerte/service_civique_alerte_repository.dart';
import 'package:pass_emploi_app/repositories/animations_collectives_repository.dart';
import 'package:pass_emploi_app/repositories/app_version_repository.dart';
import 'package:pass_emploi_app/repositories/auth/chat_security_repository.dart';
import 'package:pass_emploi_app/repositories/auth/logout_repository.dart';
import 'package:pass_emploi_app/repositories/campagne_recrutement_repository.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/configuration_application_repository.dart';
import 'package:pass_emploi_app/repositories/contact_immersion_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_encryption_local_storage.dart';
import 'package:pass_emploi_app/repositories/cv_repository.dart';
import 'package:pass_emploi_app/repositories/cvm_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_urls_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:pass_emploi_app/repositories/mon_suivi_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/repositories/preferred_login_mode_repository.dart';
import 'package:pass_emploi_app/repositories/rating_repository.dart';
import 'package:pass_emploi_app/repositories/recherches_recentes_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/search_location_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_details_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/top_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_pending_creation_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
/*AUTOGENERATE-REDUX-APP-INITIALIZER-REPOSITORY-IMPORT*/
import 'package:pass_emploi_app/utils/secure_storage_exception_handler_decorator.dart';
import 'package:pass_emploi_app/wrappers/connectivity_wrapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:synchronized/synchronized.dart';

class AppInitializer {
  Future<Widget> initializeApp() async {
    await Firebase.initializeApp();
    await _initializeCrashlytics();
    final remoteConfig = await _remoteConfig();
    final configuration = await Configuration.build();
    final matomoTracker = await _initializeMatomoTracker(configuration);
    final forceUpdate = await _shouldForceUpdate(remoteConfig);
    if (forceUpdate) {
      return ForceUpdatePage(configuration.flavor);
    } else {
      final store = await _initializeReduxStore(configuration, matomoTracker, remoteConfig);
      return PassEmploiApp(store);
    }
  }

  Future<void> _initializeCrashlytics() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  }

  Future<PassEmploiMatomoTracker> _initializeMatomoTracker(Configuration configuration) async {
    final siteId = configuration.matomoSiteId;
    final url = configuration.matomoBaseUrl;
    await PassEmploiMatomoTracker.instance.initialize(siteId: int.parse(siteId), url: url);
    return PassEmploiMatomoTracker.instance;
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

  Future<Store<AppState>> _initializeReduxStore(
    Configuration configuration,
    PassEmploiMatomoTracker matomoTracker,
    FirebaseRemoteConfig? firebaseRemoteConfig,
  ) async {
    final crashlytics = CrashlyticsWithFirebase(FirebaseCrashlytics.instance);
    final pushNotificationManager = FirebasePushNotificationManager();
    final securedPreferences = SecureStorageExceptionHandlerDecorator(
      FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true)),
    );
    final logoutRepository = LogoutRepository(
      authIssuer: configuration.authIssuer,
      clientSecret: configuration.authClientSecret,
      clientId: configuration.authClientId,
      crashlytics: crashlytics,
    );
    final authenticator = Authenticator(
      AuthWrapper(FlutterAppAuth(), Lock(), crashlytics),
      logoutRepository,
      configuration,
      securedPreferences,
      crashlytics,
    );
    final accessTokenRetriever = AuthAccessTokenRetriever(
      MaxLivingTimeRemoteConfig(firebaseRemoteConfig),
      authenticator,
      Lock(),
    );
    final authAccessChecker = AuthAccessChecker();
    final cacheStore = FileCacheStore((await getTemporaryDirectory()).path);
    final requestCacheManager = PassEmploiCacheManager(cacheStore, configuration.serverBaseUrl);
    final modeDemoRepository = ModeDemoRepository();
    final installationIdRepository = InstallationIdRepository(securedPreferences);
    final baseUrl = configuration.serverBaseUrl;
    final monitoringInterceptor = MonitoringInterceptor(installationIdRepository, AppVersionRepository());
    _setTrustedCertificatesForOldDevices(configuration, crashlytics);
    final dioClient = PassEmploiDioBuilder(
      baseUrl: baseUrl,
      cacheStore: cacheStore,
      modeDemoRepository: modeDemoRepository,
      accessTokenRetriever: accessTokenRetriever,
      authAccessChecker: authAccessChecker,
      monitoringInterceptor: monitoringInterceptor,
    ).build();
    logoutRepository.setHttpClient(dioClient);
    logoutRepository.setCacheManager(requestCacheManager);
    final chatCrypto = ChatCrypto();
    final cryptoStorage = ChatEncryptionLocalStorage(storage: securedPreferences);
    final firebaseInstanceIdGetter = FirebaseInstanceIdGetter();
    final reduxStore = StoreFactory(
      configuration,
      authenticator,
      crashlytics,
      chatCrypto,
      cryptoStorage,
      requestCacheManager,
      ConnectivityWrapper.fromConnectivity(),
      UserActionRepository(dioClient, crashlytics),
      UserActionPendingCreationRepository(securedPreferences),
      PageDemarcheRepository(dioClient, crashlytics),
      RendezvousRepository(dioClient, crashlytics),
      OffreEmploiRepository(dioClient, crashlytics),
      ChatRepository(chatCrypto, crashlytics, modeDemoRepository),
      ConfigurationApplicationRepository(dioClient, firebaseInstanceIdGetter, pushNotificationManager, crashlytics),
      OffreEmploiDetailsRepository(dioClient, crashlytics),
      OffreEmploiFavorisRepository(dioClient, crashlytics),
      ImmersionFavorisRepository(dioClient, crashlytics),
      ServiceCiviqueFavorisRepository(dioClient, crashlytics),
      SearchLocationRepository(dioClient, crashlytics),
      MetierRepository(dioClient),
      ImmersionRepository(dioClient, crashlytics),
      ImmersionDetailsRepository(dioClient, crashlytics),
      ChatSecurityRepository(dioClient, crashlytics),
      FirebaseAuthWrapper(),
      TrackingEventRepository(dioClient, crashlytics),
      OffreEmploiAlerteRepository(dioClient, crashlytics),
      ImmersionAlerteRepository(dioClient, crashlytics),
      ServiceCiviqueAlerteRepository(dioClient, crashlytics),
      GetAlerteRepository(dioClient, crashlytics),
      AlerteDeleteRepository(dioClient, crashlytics),
      ServiceCiviqueRepository(dioClient, crashlytics),
      ServiceCiviqueDetailRepository(dioClient, crashlytics),
      DetailsJeuneRepository(dioClient, crashlytics),
      SuppressionCompteRepository(dioClient, crashlytics),
      modeDemoRepository,
      CampagneRepository(dioClient, crashlytics),
      matomoTracker,
      UpdateDemarcheRepository(dioClient, crashlytics),
      CreateDemarcheRepository(dioClient, crashlytics),
      SearchDemarcheRepository(dioClient, crashlytics),
      PieceJointeRepository(dioClient, PieceJointeFileSaver(), crashlytics),
      TutorialRepository(securedPreferences),
      PartageActiviteRepository(dioClient, crashlytics),
      RatingRepository(securedPreferences),
      ActionCommentaireRepository(dioClient, requestCacheManager, crashlytics),
      AgendaRepository(dioClient, crashlytics),
      SuggestionsRechercheRepository(dioClient, requestCacheManager, crashlytics),
      AnimationsCollectivesRepository(dioClient, crashlytics),
      SessionMiloRepository(dioClient, crashlytics),
      installationIdRepository,
      DiagorienteUrlsRepository(dioClient, crashlytics),
      DiagorienteMetiersFavorisRepository(dioClient, requestCacheManager, crashlytics),
      GetFavorisRepository(dioClient, crashlytics),
      RecherchesRecentesRepository(securedPreferences),
      ContactImmersionRepository(dioClient, crashlytics),
      AccueilRepository(dioClient, crashlytics),
      CvRepository(dioClient, crashlytics),
      EvenementEmploiRepository(dioClient, SecteurActiviteQueryMapper(), EvenementEmploiTypeQueryMapper(), crashlytics),
      EvenementEmploiDetailsRepository(dioClient, crashlytics),
      ThematiqueDemarcheRepository(dioClient, crashlytics),
      TopDemarcheRepository(),
      MonSuiviRepository(dioClient, crashlytics),
      CvmRepository(crashlytics),
      CampagneRecrutementRepository(securedPreferences, CampagneRecrutementRemoteConfig(firebaseRemoteConfig)),
      PreferredLoginModeRepository(securedPreferences),
      /*AUTOGENERATE-REDUX-APP-INITIALIZER-REPOSITORY-CONSTRUCTOR*/
    ).initializeReduxStore(initialState: AppState.initialState(configuration: configuration));
    accessTokenRetriever.setStore(reduxStore);
    authAccessChecker.setStore(reduxStore);
    monitoringInterceptor.setStore(reduxStore);
    chatCrypto.setStore(reduxStore);
    await pushNotificationManager.init(reduxStore);
    return reduxStore;
  }

  /// MUST BE called to make http clients work on older Android devices.
  /// See: https://stackoverflow.com/questions/69511057/flutter-on-android-7-certificate-verify-failed-with-letsencrypt-ssl-cert-after-s
  void _setTrustedCertificatesForOldDevices(
    Configuration configuration,
    CrashlyticsWithFirebase crashlytics,
  ) {
    try {
      SecurityContext.defaultContext.setTrustedCertificatesBytes(
        utf8.encode(configuration.iSRGX1CertificateForOldDevices),
      );
    } catch (e, stack) {
      crashlytics.recordNonNetworkException(e, stack);
    }
  }
}
