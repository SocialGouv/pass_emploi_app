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
import 'package:pass_emploi_app/repositories/crypto/crypto_storage.dart';
import 'package:redux/redux.dart';

class ChatInitializerMiddleware extends MiddlewareClass<AppState> {
  final FirebaseAuthRepository _repository;
  final FirebaseAuthWrapper _firebaseAuthWrapper;
  final ChatCrypto _chatCrypto;
  final ModeDemoRepository _demoRepository;
  final CryptoStorage _cryptoStorage;

  DateTime lastTry = DateTime.now();

  ChatInitializerMiddleware(
      this._repository, this._firebaseAuthWrapper, this._chatCrypto, this._demoRepository, this._cryptoStorage);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    final loginState = store.state.loginState;
    if (!_demoRepository.getModeDemo()) {
      await _handleChatInitialization(action, loginState, store, next);
    } else {
      next(action);
    }
  }

  Future<void> _handleChatInitialization(
      action, LoginState loginState, Store<AppState> store, NextDispatcher next) async {
    if (action is TryConnectChatAgainAction && loginState is LoginSuccessState) {
      if (DateTime.now().isAfter(lastTry.add(Duration(seconds: 10)))) {
        lastTry = DateTime.now();
        await _initializeChatAndSubscribeToChatStatus(loginState.user.id);
        store.dispatch(SubscribeToChatAction());
      }
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

  Future<void> _initializeChatFirstThenDispatchLogin(
    LoginSuccessAction action,
    NextDispatcher next,
    Store<AppState> store,
  ) async {
    await _initializeChatAndSubscribeToChatStatus(action.user.id);
    next(action);
    store.dispatch(SubscribeToChatStatusAction());
  }

  Future<void> _dispatchLoginFirstThenInitializeChat(
    LoginSuccessAction action,
    NextDispatcher next,
    Store<AppState> store,
  ) async {
    next(action);
    await _initializeChatAndSubscribeToChatStatus(action.user.id);
    store.dispatch(SubscribeToChatStatusAction());
  }

  Future<void> _initializeChatAndSubscribeToChatStatus(String userId) async {
    final response = await _repository.getFirebaseAuth(userId);
    if (response != null) {
      await _firebaseAuthWrapper.signInWithCustomToken(response.token);
      _chatCrypto.setKey(response.key);
      _cryptoStorage.saveKey(response.key, userId);
    } else {
      final key = await _cryptoStorage.getKey(userId);
      _chatCrypto.setKey(key);
    }
  }
}
