import 'dart:async';

import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/cvm/cvm_event.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_repository.dart';

class CvmFacade {
  final CvmRepository _repository;
  final Crashlytics? _crashlytics;
  final _state = _CvmRepositoryState();
  StreamController<List<CvmEvent>>? _streamController;

  CvmFacade(this._repository, [this._crashlytics]);

  Stream<List<CvmEvent>> start() {
    _streamController?.close();
    _streamController = StreamController<List<CvmEvent>>();

    _initCvm()
        .then((_) => _subscribeToMessageStream())
        .then((_) => _subscribeToHasRoomStream())
        .then((_) => _login())
        .then((_) => _startListeningRooms())
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

  Future<bool> _initCvm() async {
    if (_state.isInit) return true;
    await _repository.initializeCvm();
    _state.isInit = true;
    return _state.isInit;
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

  Future<void> _handleHasRoom(bool hasRoom) async {
    // Required because callback is called multiple times on iOS
    if (_state.hasRoom) return;
    _state.hasRoom = hasRoom;

    if (_state.hasRoom) {
      _repository.stopListenRooms();
      if (_state.isListeningMessages) return;
      final roomJoined = await _repository.joinFirstRoom();
      if (roomJoined) _state.isListeningMessages = await _repository.startListenMessages();
    }
  }

  Future<bool> _login() async {
    if (_state.isLoggedIn) return true;
    _state.isLoggedIn = await _repository.login();
    return _state.isLoggedIn;
  }

  Future<bool> _startListeningRooms() async {
    if (_state.isListeningRooms) return true;
    _state.isListeningRooms = await _repository.startListenRooms();
    return _state.isListeningRooms;
  }
}

// Made to offer a proper retry mechanism. Only unsuccessful steps should be retried.
class _CvmRepositoryState {
  bool isInit = false;
  bool isLoggedIn = false;
  bool isSubscribingToMessageStream = false;
  bool isSubscribingToHasRoomStream = false;
  bool hasRoom = false;
  bool isListeningMessages = false;
  bool isListeningRooms = false;

  void reset() {
    // isInit is not reset because of Android behavior, which makes app crashes when trying to reinitialize CVM.
    isLoggedIn = false;
    isSubscribingToMessageStream = false;
    isSubscribingToHasRoomStream = false;
    hasRoom = false;
    isListeningMessages = false;
    isListeningRooms = false;
  }
}
