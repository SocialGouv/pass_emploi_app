import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:redux/redux.dart';

class ChatMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _repository;

  ChatMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoggedInState) {
      if (action is SubscribeToChatAction) {
        _repository.subscribeToMessages(loginState.user.id, store);
        _repository.setLastMessageSeen();
      } else if (action is SendMessageAction) {
        _repository.sendMessage(action.message);
      } else if (action is LastMessageSeenAction) {
        _repository.setLastMessageSeen();
      } else if (action is UnsubscribeFromChatAction) {
        _repository.unsubscribeToMessages();
      }
    }
  }
}
