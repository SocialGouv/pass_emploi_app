import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
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
    }
  }
}
