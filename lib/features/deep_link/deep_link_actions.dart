import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeepLinkAction {
  final RemoteMessage message;

  DeepLinkAction(this.message);
}

class LocalDeeplinkAction extends Equatable {
  final Map<String, dynamic> data;

  LocalDeeplinkAction(this.data);

  @override
  List<Object?> get props => [data];
}

class ResetDeeplinkAction {}
