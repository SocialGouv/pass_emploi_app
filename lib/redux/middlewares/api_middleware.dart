import 'package:pass_emploi_app/redux/actions/home_actions.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/home_repository.dart';
import 'package:redux/redux.dart';

class ApiMiddleware extends MiddlewareClass<AppState> {
  final HomeRepository repository;

  ApiMiddleware(this.repository);

  @override
  call(Store<dynamic> store, action, NextDispatcher next) async {
    next(action);
    if (action is LoginCompletedAction) {
      _getHome(action.user.id, next);
    } else if (action is UpdateActionStatus) {
      repository.updateActionStatus(action.actionId, action.newIsDoneValue);
    }
  }

  _getHome(String userId, NextDispatcher next) async {
    next(HomeLoadingAction());
    final home = await repository.getHome(userId);
    next(home != null ? HomeSuccessAction(home) : HomeFailureAction());
  }
}
