import 'package:pass_emploi_app/features/share_preferences/share_preferences_actions.dart';
import 'package:pass_emploi_app/features/share_preferences/share_preferences_state.dart';

SharePreferencesState sharePreferencesReducer(SharePreferencesState currentState, dynamic action) {
  if (action is SharePreferencesRequestAction) {
    return SharePreferencesLoadingState();
  } else if (action is SharePreferencesLoadingAction) {
    return SharePreferencesLoadingState();
  } else if (action is SharePreferencesSuccessAction) {
    return SharePreferencesSuccessState(action.preferences);
  } else if (action is SharePreferencesFailureAction) {
    return SharePreferencesFailureState();
  } else {
    return currentState;
  }
}
