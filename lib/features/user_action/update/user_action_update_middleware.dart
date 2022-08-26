import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionUpdateMiddleware extends MiddlewareClass<AppState> {
  final PageActionRepository _repository;

  UserActionUpdateMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is UserActionUpdateRequestAction) {
      store.dispatch(UserActionUpdateLoadingAction());
      final updatedAction = await _repository.updateActionStatus(
          action.actionId, action.newStatus);
      store.dispatch(updatedAction
          ? UserActionUpdateSuccessAction(
              actionId: action.actionId, newStatus: action.newStatus)
          : UserActionUpdateFailureAction());
    }
  }
}

// todo move ?
extension ShouldUpdateActionStatus on AppState {
  bool shouldUpdateActionStatus(String id, UserActionStatus status) {
    return shouldUpdateActionStatusOnActionListState(id, status) ||
        shouldUpdateActionStatusOnAgendaState(id, status);
  }

  bool shouldUpdateActionStatusOnActionListState(
      String id, UserActionStatus status) {
    final state = this.userActionListState;
    if (state is UserActionListSuccessState) {
      return state.userActions.shouldUpdateActionStatus(id, status);
    }
    return false;
  }

  bool shouldUpdateActionStatusOnAgendaState(
      String id, UserActionStatus status) {
    final state = this.agendaState;
    if (state is AgendaSuccessState) {
      return state.agenda.actions.shouldUpdateActionStatus(id, status);
    }
    return false;
  }
}
