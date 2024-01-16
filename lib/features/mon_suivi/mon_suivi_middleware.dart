import 'package:clock/clock.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
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
        store.dispatch(MonSuiviSuccessAction(action.period, interval, result));
      } else if (action.period.isCurrent()) {
        store.dispatch(MonSuiviFailureAction());
      }
    }
  }
}

Interval _getInterval(MonSuiviRequestAction action, Store<AppState> store) {
  return switch (action.period) {
    Period.current => _getCurrentPeriodInterval(),
    Period.previous => _getPreviousPeriodInterval(store),
    Period.next => _getNextPeriodInterval(store),
  };
}

Interval _getCurrentPeriodInterval() {
  return Interval(clock.now().toMondayOn2PreviousWeeks(), clock.now().toSundayOn2NextWeeks());
}

Interval _getPreviousPeriodInterval(Store<AppState> store) {
  final state = store.state.monSuiviState;
  if (state is MonSuiviSuccessState) {
    return Interval(
      state.interval.debut.subtract(Duration(days: 28)),
      state.interval.debut.subtract(Duration(milliseconds: 1)),
    );
  } else {
    throw Exception("Cannot get previous period if current period is not loaded");
  }
}

Interval _getNextPeriodInterval(Store<AppState> store) {
  final state = store.state.monSuiviState;
  if (state is MonSuiviSuccessState) {
    return Interval(
      state.interval.fin.add(Duration(milliseconds: 1)),
      state.interval.fin.add(Duration(days: 28)),
    );
  } else {
    throw Exception("Cannot get next period if current period is not loaded");
  }
}
