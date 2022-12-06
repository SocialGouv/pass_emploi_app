import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:matomo_tracker/src/logger.dart';
import 'package:matomo_tracker/src/matomo_event.dart';
import 'package:matomo_tracker/src/session.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DummyMatomoTracker implements MatomoTracker {
  @override
  late String contentBase;

  @override
  String? currentScreenId;

  @override
  late bool initialized;

  @override
  late Size screenResolution;

  @override
  late Session session;

  @override
  late int siteId;

  @override
  late Timer timer;

  @override
  late String url;

  @override
  String? userAgent;

  @override
  void clear() {
    // Do nothing
  }

  @override
  void dispatchEvents() {
    // Do nothing
  }

  @override
  void dispose() {
    // Do nothing
  }

  @override
  String? get getAuthToken => null;

  @override
  bool getOptOut() => false;

  @override
  Logger get log => throw UnimplementedError();

  @override
  bool? get optOut => false;

  @override
  void pause() {
    // Do nothing
  }

  @override
  // Do nothing
  Queue<MatomoEvent> get queue => throw UnimplementedError();

  @override
  void resume() {
    // Do nothing
  }

  @override
  Future<void> setOptOut({required bool optout}) {
    // Do nothing
    throw UnimplementedError();
  }

  @override
  void trackCartUpdate(
    List<TrackingOrderItem>? trackingOrderItems,
    num? subTotal,
    num? taxAmount,
    num? shippingCost,
    num? discountAmount, {
    Map<String, String>? dimensions,
  }) {
    // Do nothing
  }

  @override
  void trackDimensions(Map<String, String> dimensions) {
    // Do nothing
  }

  @override
  void trackEvent({
    required String eventCategory,
    required String action,
    String? eventName,
    int? eventValue,
    Map<String, String>? dimensions,
  }) {
    // Do nothing
  }

  @override
  void trackGoal(int goalId, {double? revenue, Map<String, String>? dimensions}) {
    // Do nothing
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
    // Do nothing
  }

  @override
  void trackOutlink(String? link, {Map<String, String>? dimensions}) {
    // Do nothing
  }

  @override
  void trackScreen(BuildContext context,
      {required String eventName, String? currentScreenId, String? path, Map<String, String>? dimensions}) {
    // Do nothing
  }

  @override
  void trackScreenWithName({
    required String widgetName,
    required String eventName,
    String? currentScreenId,
    String? path,
    Map<String, String>? dimensions,
  }) {
    // Do nothing
  }

  @override
  void trackSearch(
      {required String searchKeyword, String? searchCategory, int? searchCount, Map<String, String>? dimensions}) {
    // Do nothing
  }

  @override
  Visitor get visitor => throw UnimplementedError();

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
  void setVisitorUserId(String? userId) {
    // Do nothing
  }
}
