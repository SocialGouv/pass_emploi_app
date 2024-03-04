import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_actions.dart';
import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_state.dart';

PreferredLoginModeState preferredLoginModeReducer(PreferredLoginModeState current, dynamic action) {
  if (action is PreferredLoginModeSuccessAction) return PreferredLoginModeSuccessState(action.loginMode);
  return current;
}
