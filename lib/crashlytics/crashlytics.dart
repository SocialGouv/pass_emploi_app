import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pass_emploi_app/utils/log.dart';

abstract class Crashlytics {
  void setCustomKey(String key, String value);

  void setUserIdentifier(String identifier);

  void recordNonNetworkException(dynamic exception, [StackTrace stack, Uri? failingEndpoint]);

  void recordNonNetworkExceptionUrl(dynamic exception, [StackTrace stack, String? failingEndpoint]);

  void log(String message);
}

class CrashlyticsWithFirebase extends Crashlytics {
  final FirebaseCrashlytics instance;

  CrashlyticsWithFirebase(this.instance);

  @override
  void setCustomKey(String key, String value) => instance.setCustomKey(key, value);

  @override
  void setUserIdentifier(String identifier) => instance.setUserIdentifier(identifier);

  @override
  void recordNonNetworkExceptionUrl(dynamic exception, [StackTrace? stack, String? failingEndpoint]) {
    if (exception is SocketException) return;
    if (exception is DioException && exception.error is SocketException) return;
    final logPrefix = failingEndpoint != null ? 'Exception on $failingEndpoint' : 'Exception';
    Log.e(logPrefix, exception, stack);
    FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      reason: failingEndpoint != null ? 'Exception on $failingEndpoint' : null,
      printDetails: false,
    );
  }

  @override
  void recordNonNetworkException(dynamic exception, [StackTrace? stack, Uri? failingEndpoint]) {
    recordNonNetworkExceptionUrl(exception, stack, failingEndpoint?.toString());
  }

  @override
  void log(String message) {
    Log.d('Crashlytics log', message);
    FirebaseCrashlytics.instance.log(message);
  }
}
