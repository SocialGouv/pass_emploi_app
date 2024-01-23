import 'package:pass_emploi_app/features/user_action/details/user_action_details_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionDetailsMiddleware extends MiddlewareClass<AppState> {
  final UserActionRepository _repository;

  UserActionDetailsMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is UserActionDetailsRequestAction) {
      store.dispatch(UserActionDetailsLoadingAction());
      final result = await _repository.getUserAction(action.userActionId);
      if (result != null) {
        store.dispatch(UserActionDetailsSuccessAction(result));
      } else {
        store.dispatch(UserActionDetailsFailureAction());
      }
    }
  }
}
