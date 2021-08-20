import 'package:pass_emploi_app/models/home.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';

AppState uiActionReducer(AppState currentState, dynamic action) {
  if (action is UpdateActionStatus) {
    final userActionState = currentState.userActionState;
    if (userActionState is UserActionSuccessState) {
      final home = userActionState.home;
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
          userActionState: UserActionState.success(Home(actions: newActions, conseiller: home.conseiller)));
    } else {
      return currentState;
    }
  } else {
    return currentState;
  }
}
