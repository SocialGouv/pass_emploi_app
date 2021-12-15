import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionMiddleware extends MiddlewareClass<AppState> {
  final UserActionRepository _repository;

  UserActionMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is RequestUserActionsAction) {
      _requestUserActions(store);
    } else if (action is CreateUserAction) {
      _createUserAction(store, action.content, action.comment, action.initialStatus);
    } else if (action is UserActionDeleteAction) {
      deleteUserAction(store, action);
    } else if (action is UserActionUpdateStatusAction) {
      _repository.updateActionStatus(action.userId, action.actionId, action.newStatus);
    }
  }

  Future<void> _requestUserActions(Store<AppState> store) async {
    final loginState = store.state.loginState;
    if (loginState is LoggedInState) {
      store.dispatch(UserActionLoadingAction());
      final actions = await _repository.getUserActions(loginState.user.id);
      store.dispatch(actions != null ? UserActionSuccessAction(actions) : UserActionFailureAction());
    }
  }

  Future<void> _createUserAction(
      Store<AppState> store, String? content, String? comment, UserActionStatus status) async {
    final loginState = store.state.loginState;
    if (loginState is LoggedInState) {
      final response = await _repository.createUserAction(loginState.user.id, content, comment, status);
      if (response) {
        store.dispatch(UserActionCreatedWithSuccessAction());
        store.dispatch(RequestUserActionsAction());
      } else {
        store.dispatch(UserActionCreationFailed());
      }
    }
  }

  Future<void> deleteUserAction(Store<AppState> store, UserActionDeleteAction action) async {
    store.dispatch(UserActionDeleteLoadingAction());
    final result = await _repository.deleteUserAction(action.actionId);
    if (result) {
      store.dispatch(UserActionDeleteSuccessAction(action.actionId));
    } else {
      store.dispatch(UserActionDeleteFailureAction());
    }
  }
}
