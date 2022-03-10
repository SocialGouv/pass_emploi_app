import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/auth/firebase_auth_repository.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:redux/redux.dart';

class ChatInitializerMiddleware extends MiddlewareClass<AppState> {
  final FirebaseAuthRepository _repository;
  final FirebaseAuthWrapper _firebaseAuthWrapper;
  final ChatCrypto _chatCrypto;

  ChatInitializerMiddleware(this._repository, this._firebaseAuthWrapper, this._chatCrypto);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is LoginSuccessAction) {
      if (store.state.deepLinkState.deepLink == DeepLink.ROUTE_TO_CHAT) {
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
    }
  }
}
