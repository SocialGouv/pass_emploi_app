import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/actions/home_actions.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/actions/rendezvous_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/reducers/chat_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/login_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/rendezvous_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/ui_action_reducer.dart';
import 'package:pass_emploi_app/redux/reducers/user_action_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

import 'home_action_reducer.dart';
import 'offre_emploi_reducer.dart';

AppState reducer(AppState currentState, dynamic action) {
  if (action is LoginAction) {
    return loginReducer(currentState, action);
  } else if (action is HomeAction) {
    return homeActionReducer(currentState, action);
  } else if (action is UserActionAction) {
    return userActionReducer(currentState, action);
  } else if (action is RendezvousAction) {
    return rendezvousReducer(currentState, action);
  } else if (action is OffreEmploiAction) {
    return offreEmploiReducer(currentState, action);
  } else if (action is UiAction) {
    return uiActionReducer(currentState, action);
  } else if (action is ChatAction) {
    return chatActionReducer(currentState, action);
  } else {
    return currentState;
  }
}
