import 'package:pass_emploi_app/models/repository.dart';
import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class Middleware<REQUEST, RESULT> extends MiddlewareClass<AppState> {
  final Repository<REQUEST, RESULT> _repository;

  Middleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is Action<REQUEST, RESULT> && action.isRequest()) {
      final loginState = store.state.loginState;
      if (loginState.isSuccess()) {
        store.dispatch(Action<REQUEST, RESULT>.loading());
        final result = await _repository.fetch(loginState.getDataOrThrow().id, action.getRequestOrThrow());
        store.dispatch(result != null ? Action<REQUEST, RESULT>.success(result) : Action<REQUEST, RESULT>.failure());
      }
    }
  }
}
