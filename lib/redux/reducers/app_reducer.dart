import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';

AppState reducer(AppState currentState, dynamic action) {
  if (action is LoginCompletedAction) {
    return currentState.copyWith(loginState: LoginState.loginCompleted(action.user));
  } else {
    return currentState;
  }
}
