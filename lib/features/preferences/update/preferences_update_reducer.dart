import 'package:pass_emploi_app/features/preferences/update/preferences_update_actions.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_state.dart';

PreferencesUpdateState preferencesUpdateReducer(PreferencesUpdateState currentState, dynamic action) {
  if (action is PreferencesUpdateRequestAction) return PreferencesUpdateLoadingState();
  if (action is PreferencesUpdateLoadingAction) return PreferencesUpdateLoadingState();
  if (action is PreferencesUpdateSuccessAction) return PreferencesUpdateSuccessState();
  if (action is PreferencesUpdateFailureAction) return PreferencesUpdateFailureState();
  return currentState;
}
