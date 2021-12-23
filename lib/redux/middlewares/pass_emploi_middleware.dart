import 'package:pass_emploi_app/models/repository.dart';
import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

class PassEmploiMiddleware<REQUEST, RESULT> extends MiddlewareClass<AppState> {
  final Repository<REQUEST, RESULT> _repository;

  PassEmploiMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is RequestAction<REQUEST, RESULT>) {
      final loginState = store.state.loginState;
      if (loginState is LoggedInState) {
        store.dispatch(LoadingAction<REQUEST, RESULT>());
        final result = await _repository.fetch(loginState.user.id, action.request);
        store.dispatch(result != null ? Action.success<REQUEST, RESULT>(result) : Action.failure<REQUEST, RESULT>());
      }
    }
  }
}
