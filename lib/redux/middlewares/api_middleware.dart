import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

class ApiMiddleware extends MiddlewareClass<AppState> {
  final UserRepository _userRepository;
  final UserActionRepository _homeRepository;
  final ChatRepository _chatRepository;

  ApiMiddleware(this._userRepository, this._homeRepository, this._chatRepository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is RequestLoginAction) {
      _requestLogin(store, action);
    } else if (action is RequestHomeAction) {
      _getHome(store, action.userId);
    } else if (action is UpdateActionStatus) {
      _homeRepository.updateActionStatus(action.actionId, action.newIsDoneValue);
    } else if (action is SendMessageAction) {
      _chatRepository.sendMessage(action.message);
    }
  }

  _requestLogin(Store<AppState> store, RequestLoginAction action) async {
    store.dispatch(LoginLoadingAction(action.firstName, action.lastName));
    final user = await _userRepository.logUser(action.firstName, action.lastName);
    if (user != null) {
      _userRepository.saveUser(user);
      store.dispatch(LoggedInAction(user));
    } else {
      store.dispatch(LoginFailureAction(action.firstName, action.lastName));
    }
  }

  _getHome(Store<AppState> store, String userId) async {
    store.dispatch(UserActionLoadingAction());
    final home = await _homeRepository.getHome(userId);
    store.dispatch(home != null ? UserActionSuccessAction(home) : UserActionFailureAction());
    _chatRepository.subscribeToMessages(userId, store);
  }
}
