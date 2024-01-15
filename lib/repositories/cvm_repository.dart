import 'package:flutter/services.dart';

abstract class CvmRepository {
  Future<void> init();
  Stream<CvmMessage> getMessages();
  Future<void> sendMessage(String message);
}

class CvmMessage {
  final String id;
  final bool isFromUser;
  final String content;
  final DateTime date;

  CvmMessage({
    required this.id,
    required this.isFromUser,
    required this.content,
    required this.date,
  });

  static CvmMessage fromJson(dynamic json) {
    return CvmMessage(
      id: json['id'] as String,
      isFromUser: json['isFromUser'] as bool,
      content: json['content'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
    );
  }
}

class CvmRepositoryImpl implements CvmRepository {
  static const _cvmMethodChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/methods';
  static const _cvmEventChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/events';

  @override
  Future<void> init() async {
    try {
      const token = "zxjlJxYIMOyYnjij7RmqB12gy9Y";
      await MethodChannel(_cvmMethodChannel).invokeMethod('initializeCvm', {'token': token});
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Stream<CvmMessage> getMessages() {
    return EventChannel(_cvmEventChannel).receiveBroadcastStream().map((event) {
      print("📩 CVM Message received");
      return CvmMessage.fromJson(event);
    });
  }

  @override
  Future<void> sendMessage(String message) async {
    try {
      print("📬 Sending message to CVM: $message");
      await MethodChannel(_cvmMethodChannel).invokeMethod('sendMessage', {'message': message});
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
