import 'package:pass_emploi_app/features/preferences/preferences_actions.dart';
import 'package:pass_emploi_app/features/preferences/preferences_state.dart';

PreferencesState preferencesReducer(PreferencesState currentState, dynamic action) {
  if (action is PreferencesRequestAction) {
    return PreferencesLoadingState();
  } else if (action is PreferencesLoadingAction) {
    return PreferencesLoadingState();
  } else if (action is PreferencesSuccessAction) {
    return PreferencesSuccessState(action.preferences);
  } else if (action is PreferencesFailureAction) {
    return PreferencesFailureState();
  } else {
    return currentState;
  }
}
