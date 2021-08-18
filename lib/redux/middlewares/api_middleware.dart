import 'package:pass_emploi_app/redux/actions/home_actions.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/home_repository.dart';
import 'package:redux/redux.dart';

class ApiMiddleware extends MiddlewareClass<AppState> {
  final HomeRepository _homeRepository;
  final ChatRepository _chatRepository;

  ApiMiddleware(this._homeRepository, this._chatRepository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is LoggedInAction) {
      _getHome(action.user.id, next, store);
    } else if (action is UpdateActionStatus) {
      _homeRepository.updateActionStatus(action.actionId, action.newIsDoneValue);
    } else if (action is SendMessageAction) {
      _chatRepository.sendMessage(action.message);
    }
  }

  _getHome(String userId, NextDispatcher next, Store<AppState> store) async {
    next(HomeLoadingAction());
    final home = await _homeRepository.getHome(userId);
    next(home != null ? HomeSuccessAction(home) : HomeFailureAction());
    _chatRepository.subscribeToMessages(userId, store);
  }
}
