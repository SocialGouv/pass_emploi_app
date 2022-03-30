import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action_PE/list/user_action_PE_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:pass_emploi_app/repositories/user_action_PE_repository.dart';

class UserActionPEListMiddleware extends MiddlewareClass<AppState> {
  final UserActionPERepository _repository;

  UserActionPEListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is UserActionPEListRequestAction) {
      store.dispatch(UserActionPEListLoadingAction());
      final actions = await _repository.getUserActions(loginState.user.id);
      store.dispatch(actions != null ? UserActionPEListSuccessAction(actions) : UserActionPEListFailureAction());
    }
  }
}