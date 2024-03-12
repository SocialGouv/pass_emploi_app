import 'package:flutter/services.dart';
import 'package:pass_emploi_app/models/chat/cvm_message.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_aggregator.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_event_factory.dart';
import 'package:pass_emploi_app/utils/log.dart';

// Methods calls are not try/catch.
// It is caller responsibility to handle errors.
class CvmBridge {
  static const _cvmMethodChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/methods';
  static const _cvmEventChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/events';
  static const _cvmRoomsChannel = 'fr.fabrique.social.gouv.pass_emploi_app/cvm_channel/rooms';
  static const int _pageLimit = 20;

  final String cvmEx160Url;
  final CvmEventFactory cvmEventFactory;
  final CvmAggregator _aggregator;

  CvmBridge({
    required this.cvmEx160Url,
    required this.cvmEventFactory,
  }) : _aggregator = CvmAggregator();

  Future<void> initializeCvm() async {
    Log.d('--- CvmRepository.initializeCvm…');
    await MethodChannel(_cvmMethodChannel).invokeMethod('initializeCvm', {'limit': _pageLimit});
    Log.d('--- CvmRepository.initializeCvm ✅');
  }

  Future<bool> login(String cvmToken) async {
    Log.d('--- CvmRepository.login…');
    final success = await MethodChannel(_cvmMethodChannel) //
            .invokeMethod<bool>('login', {'token': cvmToken, 'ex160': cvmEx160Url}) ??
        false;
    Log.d('--- CvmRepository.login: ${success ? '✅' : '❌'}');
    return success;
  }

  Future<void> logout() async {
    Log.d('--- CvmRepository.logout…');
    _aggregator.clear();
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

  Stream<List<CvmMessage>> getMessages() {
    Log.d('--- CvmRepository.getMessages…');
    return EventChannel(_cvmEventChannel).receiveBroadcastStream().map((events) {
      final eventsJson = events as List<dynamic>;
      final cvmEvents = eventsJson
          .map((e) => cvmEventFactory.fromJson(e)) //
          .whereType<CvmMessage>()
          .toList();
      _aggregator.addEvents(cvmEvents);
      Log.d('--- CvmRepository.getMessages ✅');
      return _aggregator.getSortedEvents();
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
