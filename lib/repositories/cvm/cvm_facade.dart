import 'dart:async';

import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/chat/cvm_message.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_bridge.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_token_repository.dart';

class CvmFacade {
  static const int _timeout_in_seconds = 10;

  final CvmBridge _bridge;
  final CvmTokenRepository _tokenRepository;
  final Crashlytics? _crashlytics;
  final _CvmState _state;
  StreamController<List<CvmMessage>>? _streamController;

  CvmFacade(this._bridge, this._tokenRepository, [this._crashlytics]) : _state = _CvmState();

  Stream<List<CvmMessage>> start(String userId) {
    _streamController = StreamController<List<CvmMessage>>();
    _assertInteractionsOnStreamBeforeTimeout();

    _subscribeToMessageStream()
        .then((_) => _initCvm())
        .then((_) => _getToken(userId))
        .then((_) => _login())
        .then((_) => _joinRoom())
        .then((isRoomJoined) => isRoomJoined ? _startListenMessages() : _getRoomsAndJoin())
        .catchError((Object error) => _addErrorToStream(error));

    return _streamController!.stream;
  }

  void stop() {
    _streamController?.close();
    _state.reset();
  }

  Future<void> logout() async => await _bridge.logout();

  Future<bool> sendMessage(String message) async {
    try {
      return await _bridge.sendMessage(message);
    } catch (e, s) {
      _crashlytics?.log("CvmFacade.sendMessage error");
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<void> loadMore() async {
    try {
      return await _bridge.loadMore();
    } catch (e, s) {
      _crashlytics?.log("CvmFacade.loadMore error");
      _crashlytics?.recordCvmException(e, s);
    }
  }

  Future<bool> markAsRead(String messageId) async {
    try {
      return await _bridge.markAsRead(messageId);
    } catch (e, s) {
      _crashlytics?.log("CvmFacade.markAsRead error");
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<void> _initCvm() async {
    if (_state.isInit) return;
    await _bridge.initializeCvm();
    _state.isInit = true;
  }

  Future<void> _getToken(String userId) async {
    _state.token = await _tokenRepository.getToken(userId);
  }

  Future<bool> _login() async {
    if (_state.token == null) return false;
    _state.isLoggedIn = await _bridge.login(_state.token!);
    return _state.isLoggedIn;
  }

  Future<void> _subscribeToMessageStream() async {
    _bridge.getMessages().listen(
          (messages) => _addMessagesToStream(messages),
          onError: (Object error) => _addErrorToStream(error),
        );
  }

  Future<bool> _joinRoom() async {
    if (!_state.isLoggedIn) return false;
    _state.isRoomJoined = await _bridge.joinFirstRoom();
    return _state.isRoomJoined;
  }

  Future<void> _startListenMessages() async {
    if (!_state.isRoomJoined) return;
    await _bridge.startListenMessages();
  }

  Future<bool> _getRoomsAndJoin() async {
    if (!_state.isLoggedIn) return false;
    await _subscribeToHasRoomStream();
    return await _startListeningRooms();
  }

  Future<bool> _startListeningRooms() async {
    return await _bridge.startListenRooms();
  }

  Future<void> _subscribeToHasRoomStream() async {
    _bridge.hasRoom().listen(
      (hasRoom) async {
        // Required because callback is called multiple times on iOS
        if (_state.hasRoom) return;
        if (!hasRoom) return;
        _state.hasRoom = true;
        await _bridge.stopListenRooms();
        await _joinRoom();
        await _startListenMessages();
      },
      onError: (Object error) => _addErrorToStream(error),
    );
  }

  void _assertInteractionsOnStreamBeforeTimeout() {
    Future.delayed(Duration(seconds: _timeout_in_seconds), () {
      if (!_state.hasInteractionOnStream) _streamController?.addError(_NoInteractionOnSteamError());
    });
  }

  void _addMessagesToStream(List<CvmMessage> messages) {
    _state.hasInteractionOnStream = true;
    _streamController?.add(messages);
  }

  void _addErrorToStream(Object error) {
    _state.hasInteractionOnStream = true;
    _crashlytics?.recordCvmException(error);
    _streamController?.addError(error);
  }
}

class _NoInteractionOnSteamError extends Error {
  @override
  String toString() => "Nothing happens on stream";
}

// Made both to ensure if steps should be called, and to offer a proper retry mechanism.
class _CvmState {
  bool isInit = false;
  String? token;
  bool isLoggedIn = false;
  bool isRoomJoined = false;
  bool hasRoom = false;
  bool hasInteractionOnStream = false;

  void reset() {
    // isInit is not reset because of Android behavior, which makes app crashes when trying to reinitialize CVM.
    token = null;
    isLoggedIn = false;
    isRoomJoined = false;
    hasRoom = false;
    hasInteractionOnStream = false;
  }
}
