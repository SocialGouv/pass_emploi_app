import 'package:clock/clock.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/mon_suivi_repository.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

const _maxYearsInFutureForPeUsers = 3;

class MonSuiviMiddleware extends MiddlewareClass<AppState> {
  final MonSuiviRepository _monSuiviRepository;
  final RemoteConfigRepository _remoteConfigRepository;

  MonSuiviMiddleware(this._monSuiviRepository, this._remoteConfigRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId == null) return;
    if (action is MonSuiviRequestAction) {
      if (action.period.isCurrent) store.dispatch(MonSuiviLoadingAction());
      final interval = _getInterval(store, action);
      final result = await _getMonSuivi(store, userId, interval);
      if (result != null) {
        store.dispatch(MonSuiviSuccessAction(action.period, interval, result));
      } else if (action.period.isCurrent) {
        store.dispatch(MonSuiviFailureAction());
      }
    }
    if (_needUpdatingMonSuivi(store, action)) {
      store.dispatch(MonSuiviResetAction());
      store.dispatch(MonSuiviRequestAction(MonSuiviPeriod.current));
    }
  }

  Interval _getInterval(Store<AppState> store, MonSuiviRequestAction action) {
    return switch (action.period) {
      MonSuiviPeriod.current => _getCurrentPeriodInterval(store),
      MonSuiviPeriod.previous => _getPreviousPeriodInterval(store),
      MonSuiviPeriod.next => _getNextPeriodInterval(store),
    };
  }

  Future<MonSuivi?> _getMonSuivi(Store<AppState> store, String userId, Interval interval) async {
    if (store.state.isPeLoginMode()) return _monSuiviRepository.getMonSuiviPoleEmploi(userId, interval.debut);
    return _monSuiviRepository.getMonSuiviMilo(userId, interval);
  }

  Interval _getCurrentPeriodInterval(Store<AppState> store) {
    if (store.state.isPeLoginMode()) {
      final months = _remoteConfigRepository.monSuiviPoleEmploiStartDateInMonths();
      return Interval(
        clock.now().toMondayOn2PreviousWeeks().subtract(Duration(days: 31 * months)).toStartOfDay(),
        clock.now().add(Duration(days: 365 * _maxYearsInFutureForPeUsers)).toEndOfDay(),
      );
    }
    return Interval(clock.now().toMondayOn2PreviousWeeks(), clock.now().toSundayOn2NextWeeks());
  }

  Interval _getPreviousPeriodInterval(Store<AppState> store) {
    return switch (store.state.monSuiviState) {
      final MonSuiviSuccessState state => state.interval.toPrevious4Weeks(),
      _ => throw Exception("Cannot get previous period if current period is not loaded"),
    };
  }

  Interval _getNextPeriodInterval(Store<AppState> store) {
    return switch (store.state.monSuiviState) {
      final MonSuiviSuccessState state => state.interval.toNext4Weeks(),
      _ => throw Exception("Cannot get next period if current period is not loaded"),
    };
  }

  bool _needUpdatingMonSuivi(Store<AppState> store, dynamic action) {
    if (store.state.monSuiviState is! MonSuiviSuccessState) return false;
    return switch (action) {
      UserActionCreateSuccessAction _ => true,
      CreateDemarcheSuccessAction _ => true,
      UpdateDemarcheSuccessAction _ => true,
      _ => false,
    };
  }
}
