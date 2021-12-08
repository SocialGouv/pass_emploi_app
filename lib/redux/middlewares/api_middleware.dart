import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

class ApiMiddleware extends MiddlewareClass<AppState> {
  final UserActionRepository _userActionRepository;
  final ChatRepository _chatRepository;

  ApiMiddleware(
    this._userActionRepository,
    this._chatRepository,
  );

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is UpdateActionStatus) {
      _userActionRepository.updateActionStatus(action.userId, action.actionId, action.newStatus);
    } else if (action is SendMessageAction) {
      _chatRepository.sendMessage(action.message);
    } else if (action is LastMessageSeenAction) {
      _chatRepository.setLastMessageSeen();
    }
  }
}
