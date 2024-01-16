import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';

MonSuiviState monSuiviReducer(MonSuiviState current, dynamic action) {
  if (action is MonSuiviLoadingAction) return MonSuiviLoadingState();
  if (action is MonSuiviFailureAction) return MonSuiviFailureState();
  if (action is MonSuiviResetAction) return MonSuiviNotInitializedState();
  if (action is MonSuiviSuccessAction) return MonSuiviSuccessState(action.interval, action.monSuivi);
  return current;
}
