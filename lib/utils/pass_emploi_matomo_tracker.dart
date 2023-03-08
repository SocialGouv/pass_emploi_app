import 'dart:async';

import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassEmploiMatomoTracker {
  final MatomoTracker _decorated = MatomoTracker.instance;
  Map<String, String>? _dimensions;
  Function(String)? onTrackScreen;

  static final instance = PassEmploiMatomoTracker._internal();

  PassEmploiMatomoTracker._internal();

  Future<void> initialize({
    required int siteId,
    required String url,
    String? visitorId,
    String? contentBaseUrl,
    int dequeueInterval = 10,
    String? tokenAuth,
    SharedPreferences? prefs,
    PackageInfo? packageInfo,
  }) {
    return _decorated.initialize(
      siteId: siteId,
      url: url,
      visitorId: visitorId,
      contentBaseUrl: contentBaseUrl,
      dequeueInterval: dequeueInterval,
      tokenAuth: tokenAuth,
      prefs: prefs,
      packageInfo: packageInfo,
    );
  }

  Future<void> setOptOut({required bool optout}) => _decorated.setOptOut(optout: optout);

  void setDimensions(Map<String, String> dimensions) {
    _dimensions = dimensions.map((key, value) => MapEntry('dimension$key', Uri.encodeComponent(value)));
  }

  void trackScreen(String widgetName) {
    _decorated.trackScreenWithName(
      widgetName: widgetName,
      eventName: widgetName,
      path: widgetName,
      dimensions: _dimensions,
    );
    onTrackScreen?.call(widgetName);
  }

  void trackEvent({required String eventCategory, required String action, String? eventName, int? eventValue}) {
    _decorated.trackEvent(
      eventCategory: eventCategory,
      action: action,
      eventName: eventName,
      eventValue: eventValue,
      dimensions: _dimensions,
    );
  }

  void trackOutlink(String? link) {
    _decorated.trackOutlink(link, dimensions: _dimensions);
  }
}
