import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';

LoginState loginReducer(LoginState current, dynamic action) {
  if (action is NotLoggedInAction) return UserNotLoggedInState();
  if (action is LoginLoadingAction) return LoginLoadingState();
  if (action is LoginFailureAction) return LoginGenericFailureState(action.message);
  if (action is LoginWrongDeviceClockAction) return LoginWrongDeviceClockState();
  if (action is LoginSuccessAction) return LoginSuccessState(action.user);
  return current;
}
