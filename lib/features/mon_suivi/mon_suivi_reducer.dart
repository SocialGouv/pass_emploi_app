import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/user_action.dart';

MonSuiviState monSuiviReducer(MonSuiviState current, dynamic action) {
  if (action is MonSuiviLoadingAction) return MonSuiviLoadingState();
  if (action is MonSuiviFailureAction) return MonSuiviFailureState();
  if (action is MonSuiviResetAction) return MonSuiviNotInitializedState();
  if (action is MonSuiviSuccessAction) return _successState(current, action);
  if (action is UserActionDeleteSuccessAction) return _withDeletedAction(current, action);
  if (action is UserActionUpdateSuccessAction) return _withUpdatedAction(current, action);
  if (action is UpdateDemarcheSuccessAction) return _withUpdatedDemarche(current, action);
  return current;
}

MonSuiviSuccessState _successState(MonSuiviState current, MonSuiviSuccessAction action) {
  return switch (action.period) {
    MonSuiviPeriod.current => MonSuiviSuccessState(action.interval, action.monSuivi),
    MonSuiviPeriod.previous => _successStateForPreviousPeriod(current, action),
    MonSuiviPeriod.next => _successStateForNextPeriod(current, action),
  };
}

MonSuiviSuccessState _successStateForPreviousPeriod(MonSuiviState current, MonSuiviSuccessAction action) {
  if (current is MonSuiviSuccessState) {
    return MonSuiviSuccessState(
      Interval(action.interval.debut, current.interval.fin),
      action.monSuivi.concatenate(current.monSuivi),
    );
  } else {
    throw Exception("Cannot get previous period if current period is not loaded");
  }
}

MonSuiviSuccessState _successStateForNextPeriod(MonSuiviState current, MonSuiviSuccessAction action) {
  if (current is MonSuiviSuccessState) {
    return MonSuiviSuccessState(
      Interval(current.interval.debut, action.interval.fin),
      current.monSuivi.concatenate(action.monSuivi),
    );
  } else {
    throw Exception("Cannot get next period if current period is not loaded");
  }
}

MonSuiviState _withDeletedAction(MonSuiviState current, UserActionDeleteSuccessAction action) {
  if (current is! MonSuiviSuccessState) return current;
  return current.withUpdatedActions(current.monSuivi.actions.where((e) => e.id != action.actionId).toList());
}

MonSuiviState _withUpdatedAction(MonSuiviState current, UserActionUpdateSuccessAction action) {
  if (current is! MonSuiviSuccessState) return current;
  final newActions = current.monSuivi.actions.withUpdatedAction(action.actionId, action.request);
  return current.withUpdatedActions(newActions);
}

MonSuiviState _withUpdatedDemarche(MonSuiviState current, UpdateDemarcheSuccessAction action) {
  if (current is! MonSuiviSuccessState) return current;
  final newDemarches = current.monSuivi.demarches.withUpdatedDemarche(action.modifiedDemarche);
  return current.withUpdatedDemarches(newDemarches);
}
