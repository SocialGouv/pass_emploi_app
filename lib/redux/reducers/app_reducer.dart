import 'package:pass_emploi_app/models/home.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/actions/home_actions.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';

// TODO refacto with micro reducers
AppState reducer(AppState currentState, dynamic action) {
  if (action is LoginCompletedAction) {
    return currentState.copyWith(loginState: LoginState.loginCompleted(action.user));
  } else if (action is HomeLoadingAction) {
    return currentState.copyWith(homeState: HomeState.loading());
  } else if (action is HomeSuccessAction) {
    return currentState.copyWith(homeState: HomeState.success(action.home));
  } else if (action is HomeFailureAction) {
    return currentState.copyWith(homeState: HomeState.failure());
  } else if (action is UpdateActionStatus) {
    final homeState = currentState.homeState;
    if (homeState is HomeSuccessState) {
      final home = homeState.home;
      final actionToUpdate = home.actions.firstWhere((a) => a.id == action.actionId);
      final updatedAction = UserAction(
        id: actionToUpdate.id,
        content: actionToUpdate.content,
        isDone: action.newIsDoneValue,
        lastUpdate: DateTime.now(),
      );
      final newActions = List<UserAction>.from(home.actions).where((a) => a.id != action.actionId).toList()
        ..add(updatedAction);
      return currentState.copyWith(
          homeState: HomeState.success(Home(actions: newActions, conseiller: home.conseiller)));
    } else {
      return currentState;
    }
  } else if (action is ChatLoadingAction) {
    return currentState.copyWith(chatState: ChatState.loading());
  } else if (action is ChatSuccessAction) {
    return currentState.copyWith(chatState: ChatState.success(action.messages));
  } else if (action is ChatFailureAction) {
    return currentState.copyWith(chatState: ChatState.failure());
  } else {
    return currentState;
  }
}
