import 'dart:async';

import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/auth/firebase_auth_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:redux/redux.dart';

const _maxRetryCount = 3;

class ChatInitializerMiddleware extends MiddlewareClass<AppState> {
  final FirebaseAuthRepository _repository;
  final FirebaseAuthWrapper _firebaseAuthWrapper;
  final ChatCrypto _chatCrypto;
  final ModeDemoRepository _demoRepository;
  Timer? retryOnChatInitialization;
  int retryCount = 0;

  ChatInitializerMiddleware(this._repository, this._firebaseAuthWrapper, this._chatCrypto, this._demoRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    final loginState = store.state.loginState;
    if (!_demoRepository.getModeDemo()) {
      await _handleChatInitialization(action, loginState, store, next);
    } else {
      next(action);
    }
  }

  Future<void> _handleChatInitialization(action, LoginState loginState, Store<AppState> store, NextDispatcher next) async {
    if (action is TryConnectChatAgainAction && loginState is LoginSuccessState) {
      _retryChatInitialization(store, loginState.user.id);
    } else if (action is LoginSuccessAction) {
      if (store.state.deepLinkState is NouveauMessageDeepLinkState) {
        await _initializeChatFirstThenDispatchLogin(action, next, store);
      } else {
        await _dispatchLoginFirstThenInitializeChat(action, next, store);
      }
    } else {
      next(action);
    }
  }

  void _retryChatInitialization(Store<AppState> store, String userId) {
    retryCount++;
    if (retryCount > _maxRetryCount) {
      store.dispatch(ChatFailureAction());
      retryCount = 0;
      return;
    }
    retryOnChatInitialization?.cancel();
    retryOnChatInitialization = Timer(Duration(seconds: 1), () async {
      await _initializeChatAndSubscribeToChatStatus(userId);
      store.dispatch(SubscribeToChatAction());
    });
  }

  Future<void> _initializeChatFirstThenDispatchLogin(
    LoginSuccessAction action,
    NextDispatcher next,
    Store<AppState> store,
  ) async {
    await _initializeChatAndSubscribeToChatStatus(action.user.id);
    next(action);
    store.dispatch(SubscribeToChatStatusAction());
  }

  Future<void> _dispatchLoginFirstThenInitializeChat(LoginSuccessAction action,
      NextDispatcher next,
      Store<AppState> store,) async {
    next(action);
    await _initializeChatAndSubscribeToChatStatus(action.user.id);
    store.dispatch(SubscribeToChatStatusAction());
  }

  Future<void> _initializeChatAndSubscribeToChatStatus(String userId) async {
    final response = await _repository.getFirebaseAuth(userId);
    if (response != null) {
      await _firebaseAuthWrapper.signInWithCustomToken(response.token);
      _chatCrypto.setKey(response.key);
    }
  }
}
