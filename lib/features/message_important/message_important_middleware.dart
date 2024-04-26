import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/message_important/message_important_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:redux/redux.dart';

class MessageImportantMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _repository;

  MessageImportantMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final conseillerId = store.state.conseillerId();
    if (conseillerId == null) return;
    if (action is SubscribeToChatAction) {
      final result = await _repository.getMessageImportant(conseillerId);
      if (result != null) {
        store.dispatch(MessageImportantSuccessAction(result));
      }
    }
  }
}
