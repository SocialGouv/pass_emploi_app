import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionUpdateMiddleware extends MiddlewareClass<AppState> {
  final PageActionRepository _repository;

  UserActionUpdateMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is UserActionUpdateRequestAction) {
      _repository.updateActionStatus(action.userId, action.actionId, action.newStatus);
    }
  }
}
