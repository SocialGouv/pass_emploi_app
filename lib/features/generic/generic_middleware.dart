import 'package:pass_emploi_app/features/generic/generic_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

abstract class GenericMiddleware<T> extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final user = store.state.user();
    if (user == null) return;

    if (action is RequestAction<T>) {
      store.dispatch(LoadingAction<T>());
      final data = await getData();
      store.dispatch(data != null ? SuccessAction<T>(data) : FailureAction<T>());
    }
  }

  Future<T> getData();
}
