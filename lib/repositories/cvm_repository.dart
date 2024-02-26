import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/cvm/cvm_event.dart';
import 'package:pass_emploi_app/utils/log.dart';

// TODO-CVM Use env
const ex160 = "https://cej-conversation-va.pe-qvr.fr/identificationcej/v1/authentification/CEJ";
const token = "QTEiELzIs5Ex-A_jAiWzZu_7e9Y";

class CvmRepository {
  static const _cvmMethodChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/methods';
  static const _cvmEventChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/events';
  static const _cvmRoomsChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/rooms';

  static const int _pageLimit = 20;

  final _aggregator = _CvmEventsAggregator();
  final Crashlytics? _crashlytics;

  CvmRepository([this._crashlytics]);

  Future<bool> initializeCvm() async {
    Log.d('--- CvmRepository.initializeCvm…');
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('initializeCvm', {'limit': _pageLimit});
      Log.d('--- CvmRepository.initializeCvm ✅');
      return true;
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.initializeCvm error");
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<bool> login() async {
    Log.d('--- CvmRepository.login…');
    try {
      final success = await MethodChannel(_cvmMethodChannel) //
              .invokeMethod<bool>('login', {'token': token, 'ex160': ex160}) ??
          false;
      Log.d('--- CvmRepository.login: ${success ? '✅' : '❌'}');
      return success;
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.login error");
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<void> logout() async {
    Log.d('--- CvmRepository.logout…');
    _aggregator.reset();
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('logout');
      Log.d('--- CvmRepository.logout ✅');
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.logout error");
      _crashlytics?.recordCvmException(e, s);
    }
  }

  Future<bool> joinFirstRoom() async {
    Log.d('--- CvmRepository.joinFirstRoom…');
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('joinFirstRoom') ?? false;
      Log.d('--- CvmRepository.joinFirstRoom: ${success ? '✅' : '❌'}');
      return success;
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.joinFirstRoom error");
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<bool> startListenRooms() async {
    Log.d('--- CvmRepository.startListenRooms…');
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('startListenRoom') ?? false;
      Log.d('--- CvmRepository.startListenRooms: ${success ? '✅' : '❌'}');
      return success;
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.startListenRooms error");
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<bool> stopListenRooms() async {
    Log.d('--- CvmRepository.stopListenRooms…');
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('stopListenRoom') ?? false;
      Log.d('--- CvmRepository.stopListenRooms: ${success ? '✅' : '❌'}');
      return success;
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.stopListenRooms error");
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Stream<bool> hasRoom() {
    Log.d('--- CvmRepository.hasRoom…');
    try {
      return EventChannel(_cvmRoomsChannel).receiveBroadcastStream().map((hasRoom) {
        final hasRoomAsBool = hasRoom as bool;
        Log.d('--- CvmRepository.hasRoom: ${hasRoom ? '✅' : '❌'}');
        return hasRoomAsBool;
      });
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.hasRoom error");
      _crashlytics?.recordCvmException(e, s);
      return Stream.empty();
    }
  }

  Future<bool> startListenMessages() async {
    Log.d('--- CvmRepository.startListenMessages…');
    try {
      final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('startListenMessages') ?? false;
      Log.d('--- CvmRepository.startListenMessages: ${success ? '✅' : '❌'}');
      return success;
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.startListenMessages error");
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<void> stopListenMessages() async {
    Log.d('--- CvmRepository.stopListenMessages…');
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('stopListenMessages');
      Log.d('--- CvmRepository.stopListenMessages ✅');
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.stopListenMessages error");
      _crashlytics?.recordCvmException(e, s);
    }
  }

  Stream<List<CvmEvent>> getMessages() {
    Log.d('--- CvmRepository.getMessages…');
    try {
      return EventChannel(_cvmEventChannel).receiveBroadcastStream().map((events) {
        final eventsJson = events as List<dynamic>;
        final cvmEvents = eventsJson
            .map((e) => CvmEvent.fromJson(e, _crashlytics)) //
            .whereType<CvmEvent>()
            .toList();
        _aggregator.addEvents(cvmEvents);
        Log.d('--- CvmRepository.getMessages ✅');
        return _aggregator.getEvents();
      });
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.getMessages error");
      _crashlytics?.recordCvmException(e, s);
      return Stream.empty();
    }
  }

  Future<bool> sendMessage(String message) async {
    Log.d('--- CvmRepository.sendMessage…');
    try {
      final success = await MethodChannel(_cvmMethodChannel) //
              .invokeMethod<bool>('sendMessage', {'message': message}) ??
          false;
      Log.d('--- CvmRepository.sendMessage: ${success ? '✅' : '❌'}');
      return success;
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.sendMessage error");
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<void> loadMore() async {
    Log.d('--- CvmRepository.loadMore…');
    try {
      await MethodChannel(_cvmMethodChannel).invokeMethod('loadMore', {'limit': _pageLimit});
      Log.d('--- CvmRepository.loadMore ✅');
    } catch (e, s) {
      _crashlytics?.log("CvmRepositoryImpl.loadMore error");
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
