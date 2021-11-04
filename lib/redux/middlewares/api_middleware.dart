import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/home_actions.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/home_repository.dart';
import 'package:pass_emploi_app/repositories/create_user_action_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

class ApiMiddleware extends MiddlewareClass<AppState> {
  final UserRepository _userRepository;
  final HomeRepository _homeRepository;
  final UserActionRepository _userActionRepository;
  final ChatRepository _chatRepository;
  final CreateUserActionRepository _createUserActionRepository;

  ApiMiddleware(
    this._userRepository,
    this._homeRepository,
    this._userActionRepository,
    this._chatRepository,
    this._createUserActionRepository,
  );

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is RequestLoginAction) {
      _requestLogin(store, action);
    } else if (action is RequestHomeAction) {
      _getHome(store, action.userId);
    } else if (action is UpdateActionStatus) {
      _userActionRepository.updateActionStatus(action.userId, action.actionId, action.newStatus);
    } else if (action is SendMessageAction) {
      _chatRepository.sendMessage(action.message);
    } else if (action is LastMessageSeenAction) {
      _chatRepository.setLastMessageSeen();
    } else if (action is CreateUserAction) {
      final loginState = store.state.loginState;
      if (loginState is LoggedInState) {
        _creationAction(store, loginState.user.id, action.content, action.comment, action.initialStatus);
      }
    }
  }

  _requestLogin(Store<AppState> store, RequestLoginAction action) async {
    store.dispatch(LoginLoadingAction(action.accessCode));
    final user = await _userRepository.logUser(action.accessCode);
    if (user != null) {
      _userRepository.saveUser(user);
      store.dispatch(LoggedInAction(user));
    } else {
      store.dispatch(LoginFailureAction(action.accessCode));
    }
  }

  _getHome(Store<AppState> store, String userId) async {
    store.dispatch(HomeAction.loading());
    final home = await _homeRepository.getHome(userId);
    store.dispatch(home != null ? HomeAction.success(home) : HomeAction.failure());
    _chatRepository.subscribeToMessages(userId, store);
  }

  _creationAction(Store<AppState> store, String userId, String? content, String? comment, UserActionStatus status) async {
    final response = await _createUserActionRepository.createUserAction(userId, content, comment, status);
    if (response) {
      store.dispatch(UserActionCreatedWithSuccessAction());
    } else {
      store.dispatch(UserActionCreationFailed());
    }
  }
}
