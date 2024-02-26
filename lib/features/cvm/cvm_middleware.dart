import 'dart:async';

import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/cvm_repository.dart';
import 'package:pass_emploi_app/utils/log.dart';
import 'package:redux/redux.dart';

class CvmMiddleware extends MiddlewareClass<AppState> {
  final CvmRepository _repository;
  final Crashlytics? _crashlytics;
  final _state = _CvmRepositoryState();

  CvmMiddleware(this._repository, [this._crashlytics]);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is CvmRequestAction) {
      _startCvm(store);
    } else if (action is CvmSendMessageAction) {
      _repository.sendMessage(action.message);
    } else if (action is RequestLogoutAction) {
      _repository.logout();
      _state.reset();
    }
  }

  Future<void> _startCvm(Store<AppState> store) async {
    if (store.state.cvmState is CvmSuccessState) return;
    Log.d("CvmMiddleware _startCvm");
    store.dispatch(CvmLoadingAction());

    try {
      await _initCvm();
      _subscribeToMessageStream(store);
      _subscribeToHasRoomStream(store);
      await _login();
      await _startListeningRooms();
    } catch (error) {
      _processError(error, store);
      return;
    }

    if (_state.hasErrors()) store.dispatch(CvmFailureAction());
  }

  Future<bool> _initCvm() async {
    if (_state.isInit) return true;

    _state.isInit = await _repository.initializeCvm();
    Log.d('CvmMiddleware _isInit: ${_state.isInit ? '✅' : '❌'}');
    return _state.isInit;
  }

  void _subscribeToMessageStream(Store<AppState> store) {
    if (_state.isSubscribingToMessageStream) return;
    _state.isSubscribingToMessageStream = true;
    Log.d("CvmMiddleware _subscribeToMessageStream");

    _repository.getMessages().listen(
          (messages) => store.dispatch(CvmSuccessAction(messages)),
          onError: (error) => _processError(error, store, () => _state.isSubscribingToMessageStream = false),
        );
  }

  void _subscribeToHasRoomStream(Store<AppState> store) {
    if (_state.isSubscribingToHasRoomStream) return;
    _state.isSubscribingToHasRoomStream = true;
    Log.d("CvmMiddleware _subscribeToHasRoomStream");

    _repository.hasRoom().listen(
          (hasRoom) => _handleHasRoom(hasRoom),
          onError: (error) => _processError(error, store, () => _state.isSubscribingToHasRoomStream = false),
        );
  }

  Future<void> _handleHasRoom(bool hasRoom) async {
    // Required because callback is called multiple times on iOS
    if (_state.hasRoom) return;
    _state.hasRoom = hasRoom;
    Log.d('CvmMiddleware _state.hasRoom: ${_state.hasRoom ? '✅' : '❌'}');

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
    Log.d('CvmMiddleware _state.isLoggedIn: ${_state.isLoggedIn ? '✅' : '❌'}');
    return _state.isLoggedIn;
  }

  Future<bool> _startListeningRooms() async {
    if (_state.isListeningRooms) return true;

    _state.isListeningRooms = await _repository.startListenRooms();
    Log.d('CvmMiddleware _state.isListeningRooms: ${_state.isListeningRooms ? '✅' : '❌'}');
    return _state.isListeningRooms;
  }

  void _processError(dynamic error, Store<AppState> store, [Function()? onError]) {
    _crashlytics?.recordCvmException(error);
    onError?.call();
    store.dispatch(CvmFailureAction());
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

  bool hasErrors() {
    return !isInit ||
        !isLoggedIn ||
        !isSubscribingToMessageStream ||
        !isSubscribingToHasRoomStream ||
        !isListeningMessages ||
        !isListeningRooms;
  }
}
