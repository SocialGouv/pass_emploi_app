import 'dart:async';

import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
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
    if (loginState is LoggedInState) {
      if (action is SubscribeToChatAction) {
        _displayLoaderOnFirstTimeAndCurrentMessagesAfter(store);
        _subscribeToChatStream(loginState, store);
      } else if (action is UnsubscribeFromChatAction) {
        _messagesSubscription?.cancel();
      } else if (action is SubscribeToChatStatusAction) {
        _subscribeToChatStatusStream(loginState, store);
      } else if (action is UnsubscribeFromChatStatusAction) {
        _chatStatusSubscription?.cancel();
      } else if (action is SendMessageAction) {
        _repository.sendMessage(loginState.user.id, action.message);
      } else if (action is LastMessageSeenAction) {
        _repository.setLastMessageSeen(loginState.user.id);
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

  void _subscribeToChatStream(LoggedInState loginState, Store<AppState> store) {
    _messagesSubscription = _repository.messagesStream(loginState.user.id).listen(
          (messages) => store.dispatch(ChatSuccessAction(messages)),
          onError: (Object error, StackTrace stackTrace) => store.dispatch(ChatFailureAction()),
        );
  }

  void _subscribeToChatStatusStream(LoggedInState loginState, Store<AppState> store) {
    _chatStatusSubscription = _repository.chatStatusStream(loginState.user.id).listen(
          (info) => store.dispatch(ChatConseillerMessageAction(info.unreadMessageCount, info.lastConseillerReading)),
        );
  }
}
