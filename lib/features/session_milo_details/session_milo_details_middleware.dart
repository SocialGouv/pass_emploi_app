import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';
import 'package:redux/redux.dart';

class SessionMiloDetailsMiddleware extends MiddlewareClass<AppState> {
  final SessionMiloRepository _repository;

  SessionMiloDetailsMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is SessionMiloDetailsRequestAction) {
      store.dispatch(SessionMiloDetailsLoadingAction());
      final result = await _repository.getDetails(userId: userId, sessionId: action.sessionId);
      if (result != null) {
        store.dispatch(SessionMiloDetailsSuccessAction(result));
      } else {
        store.dispatch(SessionMiloDetailsFailureAction());
      }
    }
  }
}
