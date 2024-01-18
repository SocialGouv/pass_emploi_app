import 'package:flutter/services.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

abstract class CvmRepository {
  Future<void> initializeCvm();
  Future<void> startListenMessages();
  Stream<List<CvmEvent>> getMessages();
  Future<void> sendMessage(String message);
  Future<void> loadMore();
}

class CvmEvent {
  final String id;
  final bool isFromUser;
  final String? message;
  final DateTime? date;

  CvmEvent({
    required this.id,
    required this.isFromUser,
    required this.message,
    required this.date,
  });

  static CvmEvent fromJson(dynamic json) {
    return CvmEvent(
      id: json['id'] as String,
      isFromUser: json['isFromUser'] as bool,
      message: json['content'] as String,
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
  Future<void> initializeCvm() async {
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('initializeCvm');
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }

  @override
  Future<void> startListenMessages() async {
    try {
      const ex160 = "https://cej-conversation-va.pe-qvr.fr/identificationcej/v1/authentification/CEJ";
      const token = "kRvsHz7A5Yb8x13-xP9dvoEgHG0";
      await MethodChannel(_cvmMethodChannel).invokeMethod('startListenMessages', {'token': token, 'ex160': ex160});
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }

  @override
  Stream<List<CvmEvent>> getMessages() {
    try {
      return EventChannel(_cvmEventChannel).receiveBroadcastStream().map((events) {
        final eventsJson = events as List<dynamic>;
        return eventsJson.map((event) {
          return CvmEvent.fromJson(event);
        }).toList();
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

  @override
  Future<void> loadMore() async {
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('loadMore');
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }
}
