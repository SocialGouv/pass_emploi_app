import 'package:flutter/cupertino.dart';

import 'analytics.dart';

// Strongly inspired by FirebaseAnalyticsObserver
class AnalyticsObserver extends RouteObserver<PageRoute<dynamic>> {
  final Analytics analytics;

  AnalyticsObserver(this.analytics);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _logScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _logScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _logScreenView(previousRoute);
    }
  }

  void _logScreenView(PageRoute<dynamic> route) {
    final String? screenName = route.settings.name;
    analytics.setCurrentScreen(screenName);
  }
}
