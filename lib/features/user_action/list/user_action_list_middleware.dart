import 'package:dio/dio.dart';
import 'package:pass_emploi_app/features/campagne/campagne_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionListMiddleware extends MiddlewareClass<AppState> {
  final PageActionRepository _repository;

  UserActionListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is UserActionListRequestAction) {
      store.dispatch(UserActionListLoadingAction());
      final page = await _repository.getPageActions(loginState.user.id);
      store.dispatch(
        page != null ? UserActionListSuccessAction(page.actions) : UserActionListFailureAction(),
      );
      store.dispatch(CampagneFetchedAction(page?.campagne));
    }
  }
}
