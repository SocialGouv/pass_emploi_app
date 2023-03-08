import 'dart:async';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DummyMatomoTracker implements PassEmploiMatomoTracker {
  @override
  Function(String p1)? onTrackScreen;

  @override
  Future<void> initialize({
    required int siteId,
    required String url,
    String? visitorId,
    String? contentBaseUrl,
    int dequeueInterval = 10,
    String? tokenAuth,
    SharedPreferences? prefs,
    PackageInfo? packageInfo,
  }) async {
    // Do nothing
  }

  @override
  Future<void> setOptOut({required bool optout}) async {
    // Do nothing
  }

  @override
  void setDimensions(Map<String, String> dimensions) {
    // Do nothing
  }

  @override
  void trackScreen(String widgetName) {
    // Do nothing
  }

  @override
  void trackEvent({required String eventCategory, required String action, String? eventName, int? eventValue}) {
    // Do nothing
  }

  @override
  void trackOutlink(String? link) {
    // Do nothing
  }
}
