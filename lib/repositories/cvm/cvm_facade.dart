import 'dart:async';

import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/cvm/cvm_event.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_repository.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_token_repository.dart';

class CvmFacade {
  final CvmRepository _repository;
  final CvmTokenRepository _tokenRepository;
  final Crashlytics? _crashlytics;
  final _CvmState _state;
  StreamController<List<CvmEvent>>? _streamController;

  CvmFacade(this._repository, this._tokenRepository, [this._crashlytics]) : _state = _CvmState();

  Stream<List<CvmEvent>> start(String userId) {
    _streamController?.close();
    _streamController = StreamController<List<CvmEvent>>();

    _subscribeToMessageStream()
        .then((_) => _initCvm())
        .then((_) => _getToken(userId))
        .then((_) => _login())
        .then((_) => _joinRoom())
        .then((isRoomJoined) => isRoomJoined ? _startListenMessages() : _getRoomsAndJoin())
        .catchError((Object error) {
      _crashlytics?.recordCvmException(error);
      _streamController!.addError(error);
      return false;
    });
    return _streamController!.stream;
  }

  void stop() {
    _streamController?.close();
    _state.reset();
  }

  void logout() => _repository.logout();

  Future<bool> sendMessage(String message) async {
    try {
      return await _repository.sendMessage(message);
    } catch (e, s) {
      _crashlytics?.log("CvmFacade.sendMessage error");
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }

  Future<void> loadMore() async {
    try {
      return await _repository.loadMore();
    } catch (e, s) {
      _crashlytics?.log("CvmFacade.loadMore error");
      _crashlytics?.recordCvmException(e, s);
    }
  }

  Future<bool> _initCvm() async {
    if (_state.isInit) return true;
    await _repository.initializeCvm();
    _state.isInit = true;
    return _state.isInit;
  }

  Future<String?> _getToken(String userId) async {
    if (_state.token != null) return _state.token;
    _state.token = await _tokenRepository.getToken(userId);
    return _state.token;
  }

  Future<bool> _login() async {
    if (_state.isLoggedIn) return true;
    if (_state.token == null) return false;
    _state.isLoggedIn = await _repository.login(_state.token!);
    return _state.isLoggedIn;
  }

  Future<void> _subscribeToMessageStream() async {
    if (_state.isSubscribingToMessageStream) return;
    _state.isSubscribingToMessageStream = true;

    _repository.getMessages().listen(
      (messages) => _streamController?.add(messages),
      onError: (Object error) {
        _crashlytics?.recordCvmException(error);
        _state.isSubscribingToMessageStream = false;
        _streamController?.addError(error);
      },
    );
  }

  Future<bool> _joinRoom() async {
    if (_state.isRoomJoined) return true;
    _state.isRoomJoined = await _repository.joinFirstRoom();
    return _state.isRoomJoined;
  }

  Future<bool> _startListenMessages() async {
    if (_state.isListeningMessages) return true;
    if (!_state.isRoomJoined) return false;
    _state.isListeningMessages = await _repository.startListenMessages();
    return _state.isListeningMessages;
  }

  Future<bool> _getRoomsAndJoin() async {
    await _subscribeToHasRoomStream();
    await _startListeningRooms();
    return _state.isListeningRooms;
  }

  Future<bool> _startListeningRooms() async {
    if (_state.isListeningRooms) return true;
    _state.isListeningRooms = await _repository.startListenRooms();
    return _state.isListeningRooms;
  }

  Future<void> _subscribeToHasRoomStream() async {
    if (_state.isSubscribingToHasRoomStream) return;
    _state.isSubscribingToHasRoomStream = true;

    _repository.hasRoom().listen(
      (hasRoom) => _handleHasRoom(hasRoom),
      onError: (Object error) {
        _crashlytics?.recordCvmException(error);
        _state.isSubscribingToHasRoomStream = false;
        _streamController?.addError(error);
      },
    );
  }

  Future<bool> _handleHasRoom(bool hasRoom) async {
    // Required because callback is called multiple times on iOS
    if (_state.hasRoom) return true;
    _state.hasRoom = hasRoom;
    if (!_state.hasRoom) return false;
    await _repository.stopListenRooms();
    await _joinRoom();
    return await _startListenMessages();
  }
}

// Made to offer a proper retry mechanism. Only unsuccessful steps should be retried.
class _CvmState {
  bool isInit = false;
  String? token;
  bool isLoggedIn = false;
  bool isRoomJoined = false;
  bool isSubscribingToMessageStream = false;
  bool isSubscribingToHasRoomStream = false;
  bool hasRoom = false;
  bool isListeningMessages = false;
  bool isListeningRooms = false;

  void reset() {
    // isInit is not reset because of Android behavior, which makes app crashes when trying to reinitialize CVM.
    token = null;
    isLoggedIn = false;
    isRoomJoined = false;
    isSubscribingToMessageStream = false;
    isSubscribingToHasRoomStream = false;
    hasRoom = false;
    isListeningMessages = false;
    isListeningRooms = false;
  }
}
