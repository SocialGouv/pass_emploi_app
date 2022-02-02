import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/reducers/reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';

class LoginReducer {
  final Reducer<User> userReducer = Reducer<User>();

  AppState reduce(AppState currentState, LoginAction action) {
    if (action is RequestLogoutAction) {
      return AppState.initialState(configuration: currentState.configurationState.configuration);
    } else if (action is NotLoggedInAction) {
      return currentState.copyWith(loginState: UserNotLoggedInState());
    } else {
      return currentState.copyWith(loginState: userReducer.reduce(currentState.loginState, action));
    }
  }
}
