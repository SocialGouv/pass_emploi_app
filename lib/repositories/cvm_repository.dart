import 'package:flutter/services.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

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

  final Crashlytics? _crashlytics;

  CvmRepositoryImpl({Crashlytics? crashlytics}) : _crashlytics = crashlytics;

  @override
  Future<void> init() async {
    try {
      const ex160 = "https://cej-conversation-va.pe-qvr.fr/identificationcej/v1/authentification/CEJ";
      const token = "81KMfNeqgW8lEi5F3kYDmuqH5aE";
      await MethodChannel(_cvmMethodChannel).invokeMethod('initializeCvm', {'token': token, 'ex160': ex160});
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }

  @override
  Stream<CvmMessage> getMessages() {
    try {
      return EventChannel(_cvmEventChannel).receiveBroadcastStream().map((event) {
        return CvmMessage.fromJson(event);
      });
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return Stream.empty();
    }
  }

  @override
  Future<void> sendMessage(String message) async {
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('sendMessage', {'message': message});
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }
}
