import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/push/deep_link_factory.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/log.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:redux/redux.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final type = message.getType();
  if (type != null) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.pushNotificationEventCategory,
      action: AnalyticsEventNames.pushNotificationReceivedAction,
      eventName: type,
    );
  }
}

const String _channelId = 'high_importance_channel';
const String _channelName = 'Notifications importantes';

class FirebasePushNotificationManager extends PushNotificationManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<void> init(Store<AppState> store) async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (Platform.isIOS) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    if (Platform.isAndroid) {
      await _createHighImportanceAndroidChannel();
      _createForegroundListener(store);
    }
  }

  @override
  Future<String?> getToken() async {
    final String? token = await _firebaseMessaging.getToken();
    Log.d("FirebaseMessaging token: $token");
    return token;
  }

// TODO: Cretae a dedicated middleware
  @override
  Future<void> requestPermission() async {
    final NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    Log.d('User granted permission: ${settings.authorizationStatus}');
    _trackAuthorizationStatus(settings.authorizationStatus);
  }

  Future<void> _createHighImportanceAndroidChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      importance: Importance.max,
    );
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _createForegroundListener(Store<AppState> store) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final RemoteNotification? notification = message.notification;
      if (notification != null) {
        final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        await flutterLocalNotificationsPlugin.initialize(
            InitializationSettings(
              android: AndroidInitializationSettings('ic_notification'),
            ),
            onDidReceiveNotificationResponse: (response) => _onLocalNotificationOpened(response.payload, store));
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(_channelId, _channelName, color: const Color(0xFF3B69D1)),
            ),
            payload: jsonEncode(message.data));
      }
    });
  }

  void _onLocalNotificationOpened(String? payload, Store<AppState> store) {
    if (payload == null) return;

    final deepLink = DeepLinkFactory.fromJson(jsonDecode(payload) as Map<String, dynamic>);
    if (deepLink == null) return;

    store.dispatch(HandleDeepLinkAction(deepLink, DeepLinkOrigin.pushNotification));
  }

  void _trackAuthorizationStatus(AuthorizationStatus status) {
    final bool authorized = status == AuthorizationStatus.authorized || status == AuthorizationStatus.provisional;
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.pushNotificationAuthorizationStatusEventCategory,
      action: AnalyticsEventNames.pushNotificationAuthorizationStatusAction,
      eventName: authorized ? 'accordée' : 'non accordée',
    );
  }
}

extension Type on RemoteMessage {
  String? getType() => data["type"]?.toString();
}
