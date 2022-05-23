import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:pass_emploi_app/repositories/user_action_pe_repository.dart';

class UserActionPEListMiddleware extends MiddlewareClass<AppState> {
  final UserActionPERepository _repository;

  UserActionPEListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is UserActionPEListRequestAction) {
      store.dispatch(UserActionPEListLoadingAction());
      final homeDemarches = await _repository.getHomeDemarches(loginState.user.id);
      store.dispatch(homeDemarches != null ? UserActionPEListSuccessAction(homeDemarches.actions, homeDemarches.campagne) : UserActionPEListFailureAction());
    }
  }
}