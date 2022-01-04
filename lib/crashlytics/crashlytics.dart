import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

abstract class Crashlytics {
  void setCustomKey(String key, dynamic value);

  void recordNonNetworkException(dynamic exception, StackTrace stack, Uri failingEndpoint);
}

class CrashlyticsWithFirebase extends Crashlytics {
  final FirebaseCrashlytics instance;

  CrashlyticsWithFirebase(this.instance);

  @override
  void setCustomKey(String key, value) {
    instance.setCustomKey(key, value);
  }

  @override
  void recordNonNetworkException(dynamic exception, StackTrace stack, Uri failingEndpoint) {
    debugPrint('Exception on $failingEndpoint : ' + exception.toString());
    if (exception is SocketException) return;
    FirebaseCrashlytics.instance.recordError(exception, stack, reason: 'Exception on $failingEndpoint');
  }
}
