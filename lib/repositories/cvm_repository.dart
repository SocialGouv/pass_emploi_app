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

enum CvmEventType {
  message,
  unknown,
}

class CvmEvent {
  final String id;
  final CvmEventType type;
  final bool isFromUser;
  final String? message;
  final DateTime? date;

  CvmEvent({
    required this.id,
    required this.type,
    required this.isFromUser,
    required this.message,
    required this.date,
  });

  static CvmEvent fromJson(dynamic json) {
    return CvmEvent(
      id: json['id'] as String,
      type: json['type'] == 'message' ? CvmEventType.message : CvmEventType.unknown,
      isFromUser: json['isFromUser'] as bool,
      message: json['message'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
    );
  }
}

class CvmRepositoryImpl implements CvmRepository {
  static const _cvmMethodChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/methods';
  static const _cvmEventChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/events';
  static const _cvmRoomsChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/rooms';

  static const int _pageLimit = 20;

  final _aggregator = _CvmEventsAggregator();
  final Crashlytics? _crashlytics;

  CvmRepositoryImpl({Crashlytics? crashlytics}) : _crashlytics = crashlytics;

  @override
  Future<void> initializeCvm() async {
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('initializeCvm', {'limit': _pageLimit});
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
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
    }
  }

  @override
  Future<bool> joinFirstRoom() async {
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('joinFirstRoom') ?? false;
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
      return success;
    } catch (e, s) {
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  @override
  Future<void> loadMore() async {
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('loadMore', {'limit': _pageLimit});
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
    } else {
      _events = events;
    }
    _events.filterOnlyMessages();
    _events.sortFromOldestToNewest();
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
    sort((a, b) => a.date!.compareTo(b.date!));
  }

  void filterOnlyMessages() {
    removeWhere((element) => element.type != CvmEventType.message);
  }
}
