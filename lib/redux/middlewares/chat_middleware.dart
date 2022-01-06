import 'dart:async';

import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:redux/redux.dart';

class ChatMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _repository;
  StreamSubscription<List<Message>>? _messagesSubscription;
  StreamSubscription<ConseillerMessageInfo>? _chatStatusSubscription;

  ChatMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState.isSuccess()) {
      final userId = loginState.getResultOrThrow().id;
      if (action is SubscribeToChatAction) {
        _displayLoaderOnFirstTimeAndCurrentMessagesAfter(store);
        _subscribeToChatStream(userId, store);
      } else if (action is UnsubscribeFromChatAction) {
        _messagesSubscription?.cancel();
      } else if (action is SubscribeToChatStatusAction) {
        _subscribeToChatStatusStream(userId, store);
      } else if (action is UnsubscribeFromChatStatusAction) {
        _chatStatusSubscription?.cancel();
      } else if (action is SendMessageAction) {
        _repository.sendMessage(userId, action.message);
      } else if (action is LastMessageSeenAction) {
        _repository.setLastMessageSeen(userId);
      }
    }
  }

  void _displayLoaderOnFirstTimeAndCurrentMessagesAfter(Store<AppState> store) {
    final currentChatState = store.state.chatState;
    if (currentChatState is ChatSuccessState) {
      store.dispatch(ChatSuccessAction(currentChatState.messages));
    } else {
      store.dispatch(ChatLoadingAction());
    }
  }

  void _subscribeToChatStream(String userId, Store<AppState> store) {
    _messagesSubscription = _repository.messagesStream(userId).listen(
          (messages) => store.dispatch(ChatSuccessAction(messages)),
          onError: (Object error) => store.dispatch(ChatFailureAction()),
        );
  }

  void _subscribeToChatStatusStream(String userId, Store<AppState> store) {
    _chatStatusSubscription = _repository.chatStatusStream(userId).listen(
          (info) => store.dispatch(ChatConseillerMessageAction(info.unreadMessageCount, info.lastConseillerReading)),
        );
  }
}
