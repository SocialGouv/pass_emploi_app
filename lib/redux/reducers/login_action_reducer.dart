import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';

AppState loginReducer(AppState currentState, dynamic action) {
  if (action is LoggedInAction) {
    return currentState.copyWith(loginState: LoginState.loggedIn(action.user));
  } else if (action is NotLoggedInAction) {
    return currentState.copyWith(loginState: LoginState.notLoggedIn());
  } else if (action is LoginLoadingAction) {
    return currentState.copyWith(loginState: LoginState.loading(action.accessCode));
  } else if (action is LoginFailureAction) {
    return currentState.copyWith(loginState: LoginState.failure(action.accessCode));
  } else if (action is LogoutAction) {
    return AppState.initialState();
  } else {
    return currentState;
  }
}
