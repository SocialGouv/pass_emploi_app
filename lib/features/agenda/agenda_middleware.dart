import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';
import 'package:redux/redux.dart';

class AgendaMiddleware extends MiddlewareClass<AppState> {
  final AgendaRepository _repository;

  AgendaMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    // Need to be done before the action is dispatched to the reducer
    final int currentPendingActionsCount = store.state.userActionCreatePendingState.getPendingCreationsCount();

    next(action);

    final user = store.state.user();
    if (user == null) return;

    if (_needFetchingAgenda(currentPendingActionsCount, action)) {
      final DateTime maintenant = _getMaintenant(action);
      final Agenda? agenda;
      if (user.loginMode.isPe()) {
        agenda = await _repository.getAgendaPoleEmploi(user.id, maintenant);
      } else {
        agenda = await _repository.getAgendaMissionLocale(user.id, maintenant);
      }
      store.dispatch(agenda != null ? AgendaRequestSuccessAction(agenda) : AgendaRequestFailureAction());
    }
  }
}

DateTime _getMaintenant(dynamic action) {
  return (action is AgendaRequestAction || action is AgendaRequestReloadAction)
      ? action.maintenant as DateTime
      : DateTime.now();
}

bool _needFetchingAgenda(int currentPendingActionsCount, dynamic action) {
  return action is UserActionCreateSuccessAction ||
      action is AgendaRequestAction ||
      action is AgendaRequestReloadAction ||
      _newUserActionsCreated(currentPendingActionsCount, action);
}

bool _newUserActionsCreated(int currentPendingActionsCount, dynamic action) {
  if (action is! UserActionCreatePendingAction) return false;
  return action.pendingCreationsCount < currentPendingActionsCount;
}
