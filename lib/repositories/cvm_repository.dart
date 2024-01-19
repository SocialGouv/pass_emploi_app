import 'package:flutter/services.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

abstract class CvmRepository {
  Future<void> initializeCvm();
  Future<bool> startListenMessages();
  Future<void> stopListenMessages();
  Future<bool> sendMessage(String message);
  Future<void> loadMore();
  Stream<List<CvmEvent>> getMessages();
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
      print("CVM INITIALIZATION SUCCESS");
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }

  @override
  Future<bool> startListenMessages() async {
    try {
      final loggedIn = await _login();
      if (loggedIn == false) return false;

      final hasRoom = await _joinFirstRoom();
      if (hasRoom == false) {
        final isListeningRoom = await _listenRoom();
        if (isListeningRoom == false) return false;
      }

      return await _startListenMessages();
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<bool> _login() async {
    try {
      const ex160 = "https://cej-conversation-va.pe-qvr.fr/identificationcej/v1/authentification/CEJ";
      const token = "a16upvIV-5ewqiIsqNDluc6uk0U";
      final success =
          await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('login', {'token': token, 'ex160': ex160}) ?? false;
      print("CVM LOGIN SUCCESS: $success");
      return success;
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<bool> _joinFirstRoom() async {
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('joinFirstRoom') ?? false;
      print("CVM JOIN ROOM SUCCESS: $success");
      return success;
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<bool> _listenRoom() async {
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('startListenRoom') ?? false;
      print("CVM LISTEN ROOM SUCCESS: $success");
      return success;
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<bool> _startListenMessages() async {
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('startListenMessages') ?? false;
      print("CVM START LISTEN MESSAGES SUCCESS: $success");
      return success;
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  @override
  Future<void> stopListenMessages() async {
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('stopListenMessages');
      print("CVM STOP LISTEN MESSAGES SUCCESS");
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
  Future<bool> sendMessage(String message) async {
    try {
      final success =
          await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('sendMessage', {'message': message}) ?? false;
      print("CVM SEND MESSAGE SUCCESS: $success");
      return success;
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  @override
  Future<void> loadMore() async {
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('loadMore');
      print("CVM LOAD MORE SUCCESS");
    } on PlatformException catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }
}
