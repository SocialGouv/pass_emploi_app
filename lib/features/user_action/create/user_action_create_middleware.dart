import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionCreateMiddleware extends MiddlewareClass<AppState> {
  final UserActionRepository _repository;

  UserActionCreateMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is UserActionCreateRequestAction) {
      store.dispatch(UserActionCreateLoadingAction());
      final userActionCreatedId = await _repository.createUserAction(loginState.user.id, action.request);
      store.dispatch(userActionCreatedId != null
          ? UserActionCreateSuccessAction(userActionCreatedId)
          : UserActionCreateFailureAction(action.request));
    }
  }
}
