import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:matomo_tracker/src/logger.dart';
import 'package:matomo_tracker/src/matomo_event.dart';
import 'package:matomo_tracker/src/session.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassEmploiMatomoTracker implements MatomoTracker {
  final MatomoTracker _decorated = MatomoTracker.instance;
  Function(String)? onTrackScreen;

  static final instance = PassEmploiMatomoTracker._internal();

  PassEmploiMatomoTracker._internal();

  @override
  late String contentBase = _decorated.contentBase;

  @override
  late String? currentScreenId = _decorated.currentScreenId;

  @override
  late bool initialized = _decorated.initialized;

  @override
  late Size screenResolution = _decorated.screenResolution;

  @override
  late Session session = _decorated.session;

  @override
  late int siteId = _decorated.siteId;

  @override
  late Timer timer = _decorated.timer;

  @override
  late String url = _decorated.url;

  @override
  late String? userAgent = _decorated.userAgent;

  @override
  void clear() => _decorated.clear();

  @override
  void dispatchEvents() => _decorated.dispatchEvents();

  @override
  void dispose() => _decorated.dispose();

  @override
  String? get getAuthToken => _decorated.getAuthToken;

  @override
  bool getOptOut() => _decorated.getOptOut();

  @override
  Visitor get visitor => _decorated.visitor;

  @override
  Logger get log => _decorated.log;

  @override
  bool? get optOut => _decorated.optOut;

  @override
  Queue<MatomoEvent> get queue => _decorated.queue;

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

  @override
  void pause() => _decorated.pause();

  @override
  void resume() => _decorated.resume();

  @override
  Future<void> setOptOut({required bool optout}) => _decorated.setOptOut(optout: optout);

  @override
  void setVisitorUserId(String? userId) => _decorated.setVisitorUserId(userId);

  @override
  void trackCartUpdate(
    List<TrackingOrderItem>? trackingOrderItems,
    num? subTotal,
    num? taxAmount,
    num? shippingCost,
    num? discountAmount, {
    Map<String, String>? dimensions,
  }) {
    _decorated.trackCartUpdate(trackingOrderItems, subTotal, taxAmount, shippingCost, discountAmount);
  }

  @override
  void trackDimensions(Map<String, String> dimensions) => _decorated.trackDimensions(dimensions);

  @override
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

  @override
  void trackGoal(int goalId, {double? revenue, Map<String, String>? dimensions}) {
    _decorated.trackGoal(goalId, revenue: revenue, dimensions: dimensions);
  }

  @override
  void trackOrder(
    String? orderId,
    List<TrackingOrderItem>? trackingOrderItems,
    num? revenue,
    num? subTotal,
    num? taxAmount,
    num? shippingCost,
    num? discountAmount, {
    Map<String, String>? dimensions,
  }) {
    _decorated.trackOrder(orderId, trackingOrderItems, revenue, subTotal, taxAmount, shippingCost, discountAmount);
  }

  @override
  void trackOutlink(String? link, {Map<String, String>? dimensions}) {
    _decorated.trackOutlink(link, dimensions: dimensions);
  }

  @override
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

  @override
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

  @override
  void trackSearch({
    required String searchKeyword,
    String? searchCategory,
    int? searchCount,
    Map<String, String>? dimensions,
  }) {
    _decorated.trackSearch(
      searchKeyword: searchKeyword,
      searchCategory: searchCategory,
      searchCount: searchCount,
      dimensions: dimensions,
    );
  }
}
