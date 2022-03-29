import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_screen_tracking.dart';
import 'package:pass_emploi_app/utils/log.dart';

class AnalyticsNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _sendScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _sendScreenView(previousRoute);
    }
  }

  void _sendScreenView(Route<dynamic> route) {
    final String? routeScreenName = route.settings.name;
    if (routeScreenName != null) {
      final analyticsScreenName = AnalyticsScreenTracking.onGenerateScreenTracking(route.settings);
      if (analyticsScreenName != null) {
        Log.i("[ANALYTICS] tracked - $analyticsScreenName");
        MatomoTracker.trackScreenWithName(analyticsScreenName, "");
      } else {
        Log.i("[ANALYTICS] untracked - $routeScreenName");
      }
    } else {
      Log.w("[ANALYTICS] screen name was null");
    }
  }
}
