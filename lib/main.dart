import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pass_emploi_app/crashlytics/Crashlytics.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/pages/force_update_page.dart';
import 'package:pass_emploi_app/pass_emploi_app.dart';
import 'package:pass_emploi_app/push/firebase_push_notification_manager.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/store/store_factory.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/home_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

import 'analytics/analytics.dart';
import 'analytics/analytics_constants.dart';
import 'configuration/app_version_checker.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  final baseUrl = _baseUrl();
  final remoteConfig = await _remoteConfig();
  final forceUpdate = await _shouldForceUpdate(remoteConfig);

  final PushNotificationManager pushManager = FirebasePushNotificationManager();
  final Analytics analytics = AnalyticsLoggerDecorator(decorated: AnalyticsWithFirebase(FirebaseAnalytics()));

  final store = _initializeReduxStore(baseUrl, pushManager);

  await pushManager.init(store);

  runZonedGuarded<Future<void>>(() async {
    if (forceUpdate) {
      analytics.setCurrentScreen(AnalyticsScreenNames.forceUpdate);
      runApp(ForceUpdatePage());
    } else {
      runApp(PassEmploiApp(store, analytics));
    }
  }, FirebaseCrashlytics.instance.recordError);

  await _handleErrorsOutsideFlutter();
}

String _baseUrl() {
  // Must be declared as const https://github.com/flutter/flutter/issues/55870
  const baseUrl = String.fromEnvironment('SERVER_BASE_URL');
  if (baseUrl.isEmpty && Platform.environment['FLUTTER_TEST'] == "false") {
    throw ("A server base URL must be set in build arguments --dart-define=SERVER_BASE_URL=<YOUR_SERVER_BASE_URL>."
        "For more details, please refer to the project README.md.");
  }
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
    ChatRepository(),
    RegisterTokenRepository(
      baseUrl,
      headersBuilder,
      pushNotificationManager,
    ),
    CrashlyticsWithFirebase(FirebaseCrashlytics.instance),
  ).initializeReduxStore();
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
