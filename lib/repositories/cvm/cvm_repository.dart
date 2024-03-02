import 'package:flutter/services.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/cvm/cvm_event.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_aggregator.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_event_factory.dart';
import 'package:pass_emploi_app/utils/log.dart';

// Methods calls are not try/catch.
// It is caller responsibility to handle errors.
class CvmRepository {
  static const _cvmMethodChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/methods';
  static const _cvmEventChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/events';
  static const _cvmRoomsChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/rooms';

  // TODO-CVM Use env
  static const ex160 = "https://cej-conversation-va.pe-qvr.fr/identificationcej/v1/authentification/CEJ";
  static const token = "lIEpR_0VP-5leIKVpSiGn34C1Yo";

  static const int _pageLimit = 20;

  final _aggregator = CvmAggregator();
  final Crashlytics? _crashlytics;

  CvmRepository([this._crashlytics]);

  Future<void> initializeCvm() async {
    Log.d('--- CvmRepository.initializeCvm…');
    await MethodChannel(_cvmMethodChannel).invokeMethod('initializeCvm', {'limit': _pageLimit});
    Log.d('--- CvmRepository.initializeCvm ✅');
  }

  Future<bool> login() async {
    Log.d('--- CvmRepository.login…');
    final success = await MethodChannel(_cvmMethodChannel) //
            .invokeMethod<bool>('login', {'token': token, 'ex160': ex160}) ??
        false;
    Log.d('--- CvmRepository.login: ${success ? '✅' : '❌'}');
    return success;
  }

  Future<void> logout() async {
    Log.d('--- CvmRepository.logout…');
    _aggregator.reset();
    await MethodChannel(_cvmMethodChannel).invokeMethod('logout');
    Log.d('--- CvmRepository.logout ✅');
  }

  Future<bool> joinFirstRoom() async {
    Log.d('--- CvmRepository.joinFirstRoom…');
    final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('joinFirstRoom') ?? false;
    Log.d('--- CvmRepository.joinFirstRoom: ${success ? '✅' : '❌'}');
    return success;
  }

  Future<bool> startListenRooms() async {
    Log.d('--- CvmRepository.startListenRooms…');
    final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('startListenRoom') ?? false;
    Log.d('--- CvmRepository.startListenRooms: ${success ? '✅' : '❌'}');
    return success;
  }

  Future<bool> stopListenRooms() async {
    Log.d('--- CvmRepository.stopListenRooms…');
    final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('stopListenRoom') ?? false;
    Log.d('--- CvmRepository.stopListenRooms: ${success ? '✅' : '❌'}');
    return success;
  }

  Stream<bool> hasRoom() {
    Log.d('--- CvmRepository.hasRoom…');
    return EventChannel(_cvmRoomsChannel).receiveBroadcastStream().map((hasRoom) {
      final bool hasRoomAsBool = (hasRoom as bool?) == true;
      Log.d('--- CvmRepository.hasRoom: ${hasRoomAsBool ? '✅' : '❌'}');
      return hasRoomAsBool;
    });
  }

  Future<bool> startListenMessages() async {
    Log.d('--- CvmRepository.startListenMessages…');
    final success = await MethodChannel(_cvmMethodChannel).invokeMethod<bool>('startListenMessages') ?? false;
    Log.d('--- CvmRepository.startListenMessages: ${success ? '✅' : '❌'}');
    return success;
  }

  Future<void> stopListenMessages() async {
    Log.d('--- CvmRepository.stopListenMessages…');
    await MethodChannel(_cvmMethodChannel).invokeMethod('stopListenMessages');
    Log.d('--- CvmRepository.stopListenMessages ✅');
  }

  Stream<List<CvmEvent>> getMessages() {
    Log.d('--- CvmRepository.getMessages…');
    return EventChannel(_cvmEventChannel).receiveBroadcastStream().map((events) {
      final eventsJson = events as List<dynamic>;
      final cvmEvents = eventsJson
          .map((e) => CvmEventFactory.fromJson(e, _crashlytics)) //
          .whereType<CvmEvent>()
          .toList();
      _aggregator.addEvents(cvmEvents);
      Log.d('--- CvmRepository.getMessages ✅');
      return _aggregator.getEvents();
    });
  }

  Future<bool> sendMessage(String message) async {
    Log.d('--- CvmRepository.sendMessage…');
    final success = await MethodChannel(_cvmMethodChannel) //
            .invokeMethod<bool>('sendMessage', {'message': message}) ??
        false;
    Log.d('--- CvmRepository.sendMessage: ${success ? '✅' : '❌'}');
    return success;
  }

  Future<void> loadMore() async {
    Log.d('--- CvmRepository.loadMore…');
    await MethodChannel(_cvmMethodChannel).invokeMethod('loadMore', {'limit': _pageLimit});
    Log.d('--- CvmRepository.loadMore ✅');
  }
}
