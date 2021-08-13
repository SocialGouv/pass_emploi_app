import 'package:pass_emploi_app/models/home.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';

AppState uiActionReducer(AppState currentState, dynamic action) {
  if (action is UpdateActionStatus) {
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
  } else {
    return currentState;
  }
}
