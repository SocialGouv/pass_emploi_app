import 'package:pass_emploi_app/features/generic/generic_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

abstract class GenericMiddleware<REQUEST, RESPONSE> extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final user = store.state.user();
    if (user == null) return;

    if (action is RequestAction<REQUEST, RESPONSE>) {
      store.dispatch(LoadingAction<REQUEST, RESPONSE>());
      final data = await getData(user.id, action.request);
      store.dispatch(data != null ? SuccessAction<REQUEST, RESPONSE>(data) : FailureAction<REQUEST, RESPONSE>());
    }
  }

  Future<RESPONSE?> getData(String userId, REQUEST request);
}
