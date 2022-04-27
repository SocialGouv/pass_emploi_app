import 'package:firebase_messaging/firebase_messaging.dart';

class DeepLinkAction {
  final RemoteMessage message;

  DeepLinkAction(this.message);
}

class LocalDeeplinkAction {
  final Map<String, dynamic> data;

  LocalDeeplinkAction(this.data);
}

class ResetDeeplinkAction {}
