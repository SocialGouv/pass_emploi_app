import 'dart:async';

import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/cvm_repository.dart';
import 'package:redux/redux.dart';

class CvmMiddleware extends MiddlewareClass<AppState> {
  final CvmRepository _repository;

  CvmMiddleware(this._repository);

  var hasRoom = false; //TODO: ?
  final List<CvmEvent> messages = [];

  void _subscribeToChatStream(Store<AppState> store) {
    _repository.getMessages().listen(
      (messages) {
        store.dispatch(CvmSuccessAction(messages));
      },
      onError: (Object error) {
        store.dispatch(CvmFailureAction());
      },
    );
  }

  void _subscribeToHasRoomStream(Store<AppState> store) {
    _repository.hasRoom().listen(
      (hasRoom) {
        // TODO: est-ce qu'il faut une mécanique "synchronized" ?
        print("CVM room stream listen: $hasRoom");
        if (this.hasRoom) {
          //WHY: Le SDK iOS (et Android ?) déclenche plusieurs fois le callback.
          print("CVM room stream listen: already has a room.");
          return;
        }
        this.hasRoom = hasRoom;
        if (hasRoom) {
          _repository.stopListenRooms();
          store.dispatch(CvmJoinRoomAction());
        }
      },
      onError: (Object error) {
        store.dispatch(CvmFailureAction());
      },
    );
  }

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is CvmAction) {
      handleAction(store, action);
    }
  }

  void handleAction(Store<AppState> store, CvmAction action) async {
    if (action is CvmRequestAction) {
      await _initCvm(store, _repository);
      _loginCvm(store, _repository); //TODO: pendant qu'on a la fausse page
    } else if (action is LoginSuccessAction) {
      _loginCvm(store, _repository);
    } else if (action is CvmJoinRoomAction) {
      _startListenMessagesOnFirstRoom(store, _repository);
    } else if (action is CvmSendMessageAction) {
      _repository.sendMessage(action.message);
    } else if (action is RequestLogoutAction || action is NotLoggedInAction) {
      _repository.logout();
      hasRoom = false;
    }
    // TODO: si background/foreground ...
  }

  Future<void> _loginCvm(Store<AppState> store, CvmRepository repository) async {
    try {
      await repository.login();

      //TODO: temp to test listen rooms
      // await repository.joinFirstRoom();
      // await repository.startListenMessages();

      await repository.startListenRooms();

      Future.delayed(Duration(seconds: 5), () {
        repository.loadMore();
      });
    } catch (e) {
      store.dispatch(CvmFailureAction());
    }
  }

  Future<void> _initCvm(Store<AppState> store, CvmRepository repository) async {
    store.dispatch(CvmLoadingAction());

    try {
      hasRoom = false;

      await repository.initializeCvm();

      _subscribeToChatStream(store);
      _subscribeToHasRoomStream(store);
    } catch (e) {
      store.dispatch(CvmFailureAction());
    }
  }
}

Future<void> _startListenMessagesOnFirstRoom(Store<AppState> store, CvmRepository repository) async {
  try {
    await repository.joinFirstRoom();
    await repository.startListenMessages();
  } catch (e) {
    store.dispatch(CvmFailureAction());
  }
}

//TODO:
// action init (quand: lancement de l'app)
// => repo.initCvm
// => repo.subscribeToChatStream
// ===> quand un stream arrive, dispatch CvmSuccessAction(messages)
// => repo.subscribeToRooms
// ===> quand un stream arrive, dispatch CvmRoomsSuccessAction)

// action écouter les messages (quand: au login)
// => await repo.login
// => await repo.joinFirstRoom
// ===> si room, repo.startListenMessages
// ===> si pas de room, repo.startListenRooms

// action rejoindre une room (quand: au CvmRoomsSuccessAction)
// => repo.joinFirstRoom
// => repo.startListenMessages

// action logout
// => repo.logout
// => hasRoom = false
// => ?
