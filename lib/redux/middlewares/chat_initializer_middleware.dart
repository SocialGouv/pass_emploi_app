import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/firebase_auth_repository.dart';
import 'package:redux/redux.dart';

class ChatInitializerMiddleware extends MiddlewareClass<AppState> {
  final FirebaseAuthRepository _repository;
  final FirebaseAuthWrapper _firebaseAuthWrapper;
  final ChatCrypto _chatCrypto;

  ChatInitializerMiddleware(this._repository, this._firebaseAuthWrapper, this._chatCrypto);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is LoginAction && action.isSuccess()) {
      if (store.state.deepLinkState.deepLink == DeepLink.ROUTE_TO_CHAT) {
        await _initializeChatFirstThenDispatchLogin(action, next, store);
      } else {
        await _dispatchLoginFirstThenInitializeChat(next, action, store);
      }
    } else {
      next(action);
    }
  }

  Future<void> _initializeChatFirstThenDispatchLogin(
      LoginAction action, NextDispatcher next, Store<AppState> store) async {
    await _initializeChatAndSubscribeToChatStatus(action.getResultOrThrow().id);
    next(action);
    store.dispatch(SubscribeToChatStatusAction());
  }

  Future<void> _dispatchLoginFirstThenInitializeChat(
      NextDispatcher next, LoginAction action, Store<AppState> store) async {
    next(action);
    await _initializeChatAndSubscribeToChatStatus(action.getResultOrThrow().id);
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
