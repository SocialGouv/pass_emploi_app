import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
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
      store.dispatch(UserActionLoadingAction());
      final actions = await _repository.getUserActions(action.userId);
      store.dispatch(actions != null ? UserActionSuccessAction(actions) : UserActionFailureAction());
    } else if (action is CreateUserAction) {
      final loginState = store.state.loginState;
      if (loginState is LoggedInState) {
        _creationAction(store, loginState.user.id, action.content, action.comment, action.initialStatus);
      }
    }
  }

  _creationAction(
    Store<AppState> store,
    String userId,
    String? content,
    String? comment,
    UserActionStatus status,
  ) async {
    final response = await _repository.createUserAction(userId, content, comment, status);
    if (response) {
      store.dispatch(UserActionCreatedWithSuccessAction());
    } else {
      store.dispatch(UserActionCreationFailed());
    }
  }
}
