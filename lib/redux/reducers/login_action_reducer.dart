import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

AppState loginReducer(AppState currentState, LoginAction action) {
  if (action is LoggedInAction) {
    return currentState.copyWith(loginState: State<User>.success(action.user));
  } else if (action is NotLoggedInAction) {
    return currentState.copyWith(loginState: UserNotLoggedInState());
  } else if (action is LoginLoadingAction) {
    return currentState.copyWith(loginState: State<User>.loading());
  } else if (action is LoginFailureAction) {
    return currentState.copyWith(loginState: State<User>.failure());
  } else if (action is RequestLogoutAction) {
    return AppState.initialState();
  } else {
    return currentState;
  }
}
