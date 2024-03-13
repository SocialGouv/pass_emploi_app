import 'dart:async';

import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:redux/redux.dart';

class ChatStatusMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _repository;
  StreamSubscription<ConseillerMessageInfo>? _subscription;

  ChatStatusMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is SubscribeToChatStatusAction) {
      _subscribeToChatStatusStream(loginState.user.id, store);
    } else if (action is UnsubscribeFromChatStatusAction) {
      _subscription?.cancel();
    }
  }

  void _subscribeToChatStatusStream(String userId, Store<AppState> store) {
    _subscription = _repository.chatStatusStream(userId).listen(
          (info) => store.dispatch(ChatConseillerMessageAction(info)),
        );
  }
}
