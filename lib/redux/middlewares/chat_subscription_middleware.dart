import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:redux/redux.dart';

class ChatSubscriptionMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _repository;

  ChatSubscriptionMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is LoggedInAction) {
      _repository.subscribeToMessages(action.user.id, store);
    }
  }
}
