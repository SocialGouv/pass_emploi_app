import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/actions/home_actions.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/reducers/chat_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/home_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/ui_action_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';

AppState reducer(AppState currentState, dynamic action) {
  if (action is LoginCompletedAction) {
    return currentState.copyWith(loginState: LoginState.loginCompleted(action.user));
  } else if (action is HomeAction) {
    return homeActionReducer(currentState, action);
  } else if (action is UiAction) {
    return uiActionReducer(currentState, action);
  } else if (action is ChatAction) {
    return chatActionReducer(currentState, action);
  } else {
    return currentState;
  }
}
