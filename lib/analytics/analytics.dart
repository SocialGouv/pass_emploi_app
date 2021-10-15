import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';

abstract class Analytics {
  void setCurrentScreen(String? screenName);
}

class AnalyticsWithFirebase extends Analytics {
  final FirebaseAnalytics firebaseAnalytics;

  AnalyticsWithFirebase(this.firebaseAnalytics);

  @override
  void setCurrentScreen(String? screenName) {
    firebaseAnalytics.setCurrentScreen(screenName: screenName);
  }
}

class AnalyticsLoggerDecorator extends Analytics {
  final Analytics decorated;

  AnalyticsLoggerDecorator({required this.decorated});

  @override
  void setCurrentScreen(String? screenName) {
    log("currentScreen : $screenName", name: "ANALYTICS");
    decorated.setCurrentScreen(screenName);
  }
}