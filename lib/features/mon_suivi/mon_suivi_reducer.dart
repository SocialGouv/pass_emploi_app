import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/models/date/interval.dart';

MonSuiviState monSuiviReducer(MonSuiviState current, dynamic action) {
  if (action is MonSuiviLoadingAction) return MonSuiviLoadingState();
  if (action is MonSuiviFailureAction) return MonSuiviFailureState();
  if (action is MonSuiviResetAction) return MonSuiviNotInitializedState();
  if (action is MonSuiviSuccessAction) return _successState(current, action);
  return current;
}

MonSuiviSuccessState _successState(MonSuiviState current, MonSuiviSuccessAction action) {
  return switch (action.period) {
    Period.current => MonSuiviSuccessState(action.interval, action.monSuivi),
    Period.previous => _successStateForPreviousPeriod(current, action),
    Period.next => throw Exception("TODO"),
  };
}

MonSuiviSuccessState _successStateForPreviousPeriod(MonSuiviState current, MonSuiviSuccessAction action) {
  if (current is MonSuiviSuccessState) {
    return MonSuiviSuccessState(
      Interval(action.interval.debut, current.interval.fin),
      action.monSuivi.append(current.monSuivi),
    );
  } else {
    throw Exception("Cannot get previous period if current period is not loaded");
  }
}
