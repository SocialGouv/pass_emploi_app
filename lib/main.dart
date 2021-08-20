import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pass_emploi_app.dart';
import 'package:pass_emploi_app/redux/middlewares/animation_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/api_middleware.dart';
import 'package:pass_emploi_app/redux/middlewares/router_middleware.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  final baseUrl = _baseUrl();
  final store = _initializeReduxStore(baseUrl);

  runZonedGuarded<Future<void>>(() async {
    runApp(PassEmploiApp(store));
  }, FirebaseCrashlytics.instance.recordError);

  await _handleErrorsOutsideFlutter();
}

_baseUrl() {
  // Must be declared as const https://github.com/flutter/flutter/issues/55870
  const env = String.fromEnvironment('NGROK_SERVER_ID');
  if (env.isEmpty && Platform.environment['FLUTTER_TEST'] == "false") {
    throw ("A Ngrok server ID must be set in build arguments --dart-define=NGROK_SERVER_ID=<YOUR_SERVER_ID>."
        "For more details, please refer to the project README.md.");
  }
  final baseUrl = "https://$env.ngrok.io";
  print("SERVER BASE URL = $baseUrl");
  return baseUrl;
}

Store<AppState> _initializeReduxStore(String baseUrl) {
  var userRepository = UserRepository(baseUrl);
  return Store<AppState>(
    reducer,
    initialState: AppState.initialState(),
    middleware: [
      RouterMiddleware(userRepository),
      ApiMiddleware(userRepository, UserActionRepository(baseUrl), ChatRepository()),
      AnimationMiddleware(),
    ],
  );
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
