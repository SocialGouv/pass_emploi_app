import 'dart:async';

import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_chat_repository.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:redux/redux.dart';

class ChatMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _repository;
  StreamSubscription<List<Message>>? _subscription;

  ChatMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState) {
      final userId = loginState.user.id;
      if (action is SubscribeToChatAction) {
        if (loginState.user.loginMode == LoginMode.DEMO_MILO || loginState.user.loginMode == LoginMode.DEMO_PE) {
          store.dispatch(ChatSuccessAction(modeDemoChat()));
        } else {
          _displayLoaderOnFirstTimeAndCurrentMessagesAfter(store);
          _subscribeToChatStream(userId, store);
        }
      } else if (!loginState.user.loginMode.isDemo()) {
        if (action is UnsubscribeFromChatAction) {
          _subscription?.cancel();
        } else if (action is SendMessageAction) {
          _repository.sendMessage(userId, action.message);
        } else if (action is LastMessageSeenAction) {
          _repository.setLastMessageSeen(userId);
        }
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
    _subscription = _repository.messagesStream(userId).listen(
          (messages) => store.dispatch(ChatSuccessAction(messages)),
      onError: (Object error) {
        if (error is ChatNotInitializedError) {
          store.dispatch(TryConnectChatAgainAction());
        }
        return store.dispatch(ChatFailureAction());
      },
    );
  }
}

class ChatNotInitializedError implements Exception {}