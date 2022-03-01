import 'dart:async';

import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:redux/redux.dart';

class ChatStatusMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _repository;
  StreamSubscription<ConseillerMessageInfo>? _subscription;

  ChatStatusMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is SubscribeToChatStatusAction) {
      _subscribeToChatStatusStream(loginState.getResultOrThrow().id, store);
    } else if (action is UnsubscribeFromChatStatusAction) {
      _subscription?.cancel();
    }
  }

  void _subscribeToChatStatusStream(String userId, Store<AppState> store) {
    _subscription = _repository.chatStatusStream(userId).listen(
          (info) => store.dispatch(ChatConseillerMessageAction(info.unreadMessageCount, info.lastConseillerReading)),
        );
  }
}
