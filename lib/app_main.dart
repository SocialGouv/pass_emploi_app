import 'dart:async';
import 'dart:isolate';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/app_initializer.dart';
import 'package:pass_emploi_app/models/brand.dart';

void appMain(Brand brand) async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Brand.setBrand(brand);
    final app = await AppInitializer().initializeApp();
    runApp(app);
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
  await _handleErrorsOutsideFlutter();
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
