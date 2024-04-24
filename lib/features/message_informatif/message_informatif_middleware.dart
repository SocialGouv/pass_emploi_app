import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/message_informatif/message_informatif_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:redux/redux.dart';

class MessageInformatifMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _repository;

  MessageInformatifMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final conseillerId = store.state.conseillerId() ?? "TODO: remove me";
    if (action is SubscribeToChatAction) {
      final result = await _repository.getMessageInformatif(conseillerId);
      if (result != null) {
        store.dispatch(MessageInformatifSuccessAction(result));
      }
    }
  }
}
