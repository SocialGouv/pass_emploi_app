import 'package:pass_emploi_app/redux/actions/home_actions.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/home_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

class ApiMiddleware extends MiddlewareClass<AppState> {
  final UserRepository _userRepository;
  final HomeRepository _homeRepository;
  final UserActionRepository _userActionRepository;
  final ChatRepository _chatRepository;

  ApiMiddleware(this._userRepository, this._homeRepository, this._userActionRepository, this._chatRepository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is RequestLoginAction) {
      _requestLogin(store, action);
    } else if (action is RequestHomeAction) {
      _getHome(store, action.userId);
    } else if (action is RequestUserActionsAction) {
      _getUserActions(store, action.userId);
    } else if (action is UpdateActionStatus) {
      _userActionRepository.updateActionStatus(action.userId, action.actionId, action.newIsDoneValue);
    } else if (action is SendMessageAction) {
      _chatRepository.sendMessage(action.message);
    } else if (action is LastMessageSeenAction) {
      _chatRepository.setLastMessageSeen();
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
    store.dispatch(HomeAction.loading());
    final home = await _homeRepository.getHome(userId);
    store.dispatch(home != null ? HomeAction.success(home) : HomeAction.failure());
    _chatRepository.subscribeToMessages(userId, store);
  }

  _getUserActions(Store<AppState> store, String userId) async {
    store.dispatch(UserActionLoadingAction());
    final actions = await _userActionRepository.getUserActions(userId);
    store.dispatch(actions != null ? UserActionSuccessAction(actions) : UserActionFailureAction());
  }
}
