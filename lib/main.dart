import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:matomo/matomo.dart';
import 'package:package_info/package_info.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/pages/force_update_page.dart';
import 'package:pass_emploi_app/pass_emploi_app.dart';
import 'package:pass_emploi_app/push/firebase_push_notification_manager.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/store/store_factory.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/home_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

import 'configuration/app_version_checker.dart';
import 'crashlytics/crashlytics.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  await loadEnvironmentVariables();
  await _initializeMatomoTracker();

  final baseUrl = _baseUrl();
  final remoteConfig = await _remoteConfig();
  final forceUpdate = await _shouldForceUpdate(remoteConfig);
  final PushNotificationManager pushManager = FirebasePushNotificationManager();
  final store = _initializeReduxStore(baseUrl, pushManager);

  await pushManager.init(store);

  runZonedGuarded<Future<void>>(() async {
    runApp(forceUpdate ? ForceUpdatePage() : PassEmploiApp(store));
  }, FirebaseCrashlytics.instance.recordError);

  await _handleErrorsOutsideFlutter();
}

Future<void> loadEnvironmentVariables() async {
  final packageName = (await PackageInfo.fromPlatform()).packageName;
  final isStagingFlavor = packageName.contains("staging");
  print("FLAVOR = ${isStagingFlavor ? "staging" : "prod"}");
  return await dotenv.load(fileName: isStagingFlavor ? ".env.staging" : ".env.prod");
}

Future<void> _initializeMatomoTracker() async {
  final siteId = dotenv.env['MATOMO_SITE_ID'];
  final url = dotenv.env['MATOMO_BASE_URL'];
  if (siteId == null || url == null) throw ("MATOMO_SITE_ID & MATOMO_BASE_URL must be set in .env file");
  await MatomoTracker().initialize(siteId: int.parse(siteId), url: url);
}

String _baseUrl() {
  final baseUrl = dotenv.env['SERVER_BASE_URL'];
  if (baseUrl == null) throw ("SERVER_BASE_URL must be set in .env file");
  print("SERVER BASE URL = $baseUrl");
  return baseUrl;
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

Store<AppState> _initializeReduxStore(String baseUrl, PushNotificationManager pushNotificationManager) {
  final headersBuilder = HeadersBuilder();
  final userRepository = UserRepository(baseUrl, headersBuilder);
  return StoreFactory(
    userRepository,
    HomeRepository(baseUrl, headersBuilder),
    UserActionRepository(baseUrl, headersBuilder),
    RendezvousRepository(baseUrl, headersBuilder),
    OffreEmploiRepository(baseUrl, headersBuilder),
    ChatRepository(),
    RegisterTokenRepository(
      baseUrl,
      headersBuilder,
      pushNotificationManager,
    ),
    CrashlyticsWithFirebase(FirebaseCrashlytics.instance),
  ).initializeReduxStore(initialState: AppState.initialState());
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
