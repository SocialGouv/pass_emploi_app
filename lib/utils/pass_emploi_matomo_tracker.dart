import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassEmploiMatomoTracker {
  final MatomoTracker _decorated = MatomoTracker.instance;
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

  void trackDimensions(Map<String, String> dimensions) => _decorated.trackDimensions(dimensions);

  void trackEvent({
    required String eventCategory,
    required String action,
    String? eventName,
    int? eventValue,
    Map<String, String>? dimensions,
  }) {
    _decorated.trackEvent(
      eventCategory: eventCategory,
      action: action,
      eventName: eventName,
      eventValue: eventValue,
      dimensions: dimensions,
    );
  }

  void trackOutlink(String? link, {Map<String, String>? dimensions}) {
    _decorated.trackOutlink(link, dimensions: dimensions);
  }

  void trackScreen(
    BuildContext context, {
    required String eventName,
    String? currentScreenId,
    String? path,
    Map<String, String>? dimensions,
  }) {
    _decorated.trackScreen(
      context,
      eventName: eventName,
      currentScreenId: currentScreenId,
      path: path,
      dimensions: dimensions,
    );
    onTrackScreen?.call(eventName);
  }

  void trackScreenWithName({
    required String widgetName,
    required String eventName,
    String? currentScreenId,
    String? path,
    Map<String, String>? dimensions,
  }) {
    _decorated.trackScreenWithName(
      widgetName: widgetName,
      eventName: eventName,
      currentScreenId: currentScreenId,
      path: path,
      dimensions: dimensions,
    );
    onTrackScreen?.call('$eventName in $widgetName');
  }
}
