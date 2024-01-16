import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/mon_suivi_repository.dart';
import 'package:redux/redux.dart';

class MonSuiviMiddleware extends MiddlewareClass<AppState> {
  final MonSuiviRepository _repository;

  MonSuiviMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is MonSuiviRequestAction) {
      store.dispatch(MonSuiviLoadingAction());
      final result = await _repository.getMonSuivi(userId: userId, debut: action.debut, fin: action.fin);
      if (result != null) {
        store.dispatch(MonSuiviSuccessAction(result));
      } else {
        store.dispatch(MonSuiviFailureAction());
      }
    }
  }
}
