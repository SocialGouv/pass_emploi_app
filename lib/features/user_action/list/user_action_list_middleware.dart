import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionListMiddleware extends MiddlewareClass<AppState> {
  final UserActionRepository _repository;

  UserActionListMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState.isSuccess() && action is UserActionListRequestAction) {
      store.dispatch(UserActionListLoadingAction());
      final actions = await _repository.getUserActions(loginState.getResultOrThrow().id);
      store.dispatch(actions != null ? UserActionListSuccessAction(actions) : UserActionListFailureAction());
    }
  }
}
