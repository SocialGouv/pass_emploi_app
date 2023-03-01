import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_state.dart';

DiagorientePreferencesMetierState diagorientePreferencesMetierReducer(
    DiagorientePreferencesMetierState current, dynamic action) {
  if (action is DiagorientePreferencesMetierLoadingAction) return DiagorientePreferencesMetierLoadingState();
  if (action is DiagorientePreferencesMetierFailureAction) return DiagorientePreferencesMetierFailureState();
  if (action is DiagorientePreferencesMetierSuccessAction) {
    return DiagorientePreferencesMetierSuccessState(action.result);
  }
  if (action is DiagorientePreferencesMetierResetAction) return DiagorientePreferencesMetierNotInitializedState();
  return current;
}
