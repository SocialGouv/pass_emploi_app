import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pass_emploi_app/utils/log.dart';

abstract class Crashlytics {
  void setCustomKey(String key, String value);

  void setUserIdentifier(String identifier);

  void recordNonNetworkException(dynamic exception, StackTrace stack, [Uri? failingEndpoint]);
}

class CrashlyticsWithFirebase extends Crashlytics {
  final FirebaseCrashlytics instance;

  CrashlyticsWithFirebase(this.instance);

  @override
  void setCustomKey(String key, String value) => instance.setCustomKey(key, value);

  @override
  void setUserIdentifier(String identifier) => instance.setUserIdentifier(identifier);

  @override
  void recordNonNetworkException(dynamic exception, StackTrace stack, [Uri? failingEndpoint]) {
    final logPrefix = failingEndpoint != null ? 'Exception on $failingEndpoint' : 'Exception';
    Log.e('$logPrefix: $exception');
    if (exception is SocketException) return;
    FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      reason: failingEndpoint != null ? 'Exception on $failingEndpoint' : null,
    );
  }
}
