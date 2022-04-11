import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

bool modeDemoReducer(AppState current, dynamic action) {
  if (action is LoginSuccessAction) return action.user.loginMode == LoginMode.DEMO;
  return current.demoState;
}