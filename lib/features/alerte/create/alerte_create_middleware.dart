import 'package:pass_emploi_app/features/alerte/create/alerte_create_actions.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_repository.dart';
import 'package:redux/redux.dart';

abstract class AlerteCreateMiddleware<T> extends MiddlewareClass<AppState> {
  final AlerteRepository<T> _repository;

  AlerteCreateMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is AlerteCreateRequestAction<T> && loginState is LoginSuccessState) {
      await _saveSearch(store, action, loginState.user.id);
    }
  }

  Future<void> _saveSearch(Store<AppState> store, AlerteCreateRequestAction<T> action, String userId) async {
    final alerteState = getAlerteCreateState(store);
    final T? t = alerteState is AlerteCreateInitialized<T> ? alerteState.search : null;
    if (t == null) {
      store.dispatch(AlerteCreateFailureAction<T>());
    } else {
      final result = await _repository.postAlerte(userId, t, action.title);
      store.dispatch(
        result ? AlerteCreateSuccessAction<T>(copyWithTitle(t, action.title)) : AlerteCreateFailureAction<T>(),
      );
    }
  }

  AlerteCreateState<T> getAlerteCreateState(Store<AppState> store);

  T copyWithTitle(T t, String title);
}
