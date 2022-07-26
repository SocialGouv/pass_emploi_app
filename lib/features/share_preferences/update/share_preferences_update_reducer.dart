import 'package:pass_emploi_app/features/share_preferences/update/share_preferences_update_actions.dart';
import 'package:pass_emploi_app/features/share_preferences/update/share_preferences_update_state.dart';

SharePreferencesUpdateState sharePreferencesUpdateReducer(SharePreferencesUpdateState currentState, dynamic action) {
  if (action is SharePreferencesUpdateRequestAction) {
    return SharePreferencesUpdateLoadingState();
  } else if (action is SharePreferencesUpdateLoadingAction) {
    return SharePreferencesUpdateLoadingState();
  } else if (action is SharePreferencesUpdateSuccessAction) {
    return SharePreferencesUpdateSuccessState(action.favorisShared);
  } else if (action is SharePreferencesUpdateFailureAction) {
    return SharePreferencesUpdateFailureState();
  } else {
    return currentState;
  }
}
