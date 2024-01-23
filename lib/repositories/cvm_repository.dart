import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

abstract class CvmRepository {
  Future<void> initializeCvm();
  Future<bool> login();
  Future<void> logout();
  Future<bool> startListenRooms();
  Future<void> stopListenRooms();
  Future<void> joinFirstRoom();
  Future<bool> startListenMessages();
  Future<void> stopListenMessages();
  Future<bool> sendMessage(String message);
  Future<void> loadMore();
  Stream<List<CvmEvent>> getMessages();
  Stream<bool> hasRoom();
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
  static const _cvmRoomsChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/rooms';

  final _aggregator = _CvmEventsAggregator();
  final Crashlytics? _crashlytics;

  CvmRepositoryImpl({Crashlytics? crashlytics}) : _crashlytics = crashlytics;

  @override
  Future<void> initializeCvm() async {
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('initializeCvm');
      print("CVM INITIALIZATION SUCCESS");
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }

  @override
  Future<bool> login() async {
    try {
      const ex160 = "https://cej-conversation-va.pe-qvr.fr/identificationcej/v1/authentification/CEJ";
      const token = "tC8Qkxg0FuDOBkYEAuSZ4SyFIYM";
      final success =
          await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('login', {'token': token, 'ex160': ex160}) ?? false;
      print("CVM LOGIN SUCCESS: $success");
      return success;
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  @override
  Future<void> logout() async {
    _aggregator.reset();
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('logout');
      print("CVM LOGOUT SUCCESS");
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }

  @override
  Future<bool> joinFirstRoom() async {
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('joinFirstRoom') ?? false;
      print("CVM JOIN ROOM SUCCESS: $success");
      return success;
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  @override
  Future<bool> startListenRooms() async {
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('startListenRoom') ?? false;
      print("CVM START LISTEN ROOM SUCCESS: $success");
      return success;
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  @override
  Future<bool> stopListenRooms() async {
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('stopListenRoom') ?? false;
      print("CVM STOP LISTEN ROOM SUCCESS: $success");
      return success;
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  @override
  Stream<bool> hasRoom() {
    try {
      return EventChannel(_cvmRoomsChannel).receiveBroadcastStream().map((hasRoom) {
        print("CVM HAS ROOM: $hasRoom");
        return hasRoom as bool;
      });
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return Stream.empty();
    }
  }

  @override
  Future<bool> startListenMessages() async {
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('startListenMessages') ?? false;
      print("CVM START LISTEN MESSAGES SUCCESS: $success");
      return success;
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  @override
  Future<void> stopListenMessages() async {
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('stopListenMessages');
      print("CVM STOP LISTEN MESSAGES SUCCESS");
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }

  @override
  Stream<List<CvmEvent>> getMessages() {
    try {
      return EventChannel(_cvmEventChannel).receiveBroadcastStream().map((events) {
        final eventsJson = events as List<dynamic>;
        final cvmEvents = eventsJson.map((event) {
          return CvmEvent.fromJson(event);
        }).toList();
        _aggregator.addEvents(cvmEvents);
        return _aggregator.getEvents();
      });
    } catch (e, s) {
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
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  @override
  Future<void> loadMore() async {
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('loadMore');
      print("CVM LOAD MORE SUCCESS");
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }
}

class _CvmEventsAggregator {
  List<CvmEvent> _events = [];

  void addEvents(List<CvmEvent> events) {
    if (Platform.isIOS) {
      _events = [
        ..._events.whereEventIdNotIn(events),
        ...events,
      ];
      _events.sortFromOldestToNewest();
    } else {
      _events = events;
    }
  }

  List<CvmEvent> getEvents() {
    return _events;
  }

  void reset() {
    _events = [];
  }
}

extension _IterableMessage on Iterable<CvmEvent> {
  Iterable<CvmEvent> whereEventIdNotIn(Iterable<CvmEvent> events) {
    return where((element) => !events.containsId(element.id));
  }

  bool containsId(String id) {
    return any((element) => element.id == id);
  }
}

extension _ListMessage on List<CvmEvent> {
  void sortFromOldestToNewest() {
    //TODO: la date est-elle vraiment nullable ? on jette dans le map si jamais pas de id et pas de date ?
    sort((a, b) => a.date!.compareTo(b.date!));
  }
}
