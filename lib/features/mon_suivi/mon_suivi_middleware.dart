import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/mon_suivi_repository.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
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
      if (action.period.isCurrent()) store.dispatch(MonSuiviLoadingAction());
      final interval = _getInterval(action, store);
      final result = await _repository.getMonSuivi(userId, interval);
      if (result != null) {
        store.dispatch(MonSuiviSuccessAction(interval, result));
      } else {
        store.dispatch(MonSuiviFailureAction());
      }
    }
  }
}

Interval _getInterval(MonSuiviRequestAction action, Store<AppState> store) {
  return Interval(
    DateTime.now().toMondayOn2PreviousWeeks(),
    DateTime.now().toSundayOn2NextWeeks(),
  );
}
