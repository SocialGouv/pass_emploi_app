import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/agenda_repository.dart';
import 'package:redux/redux.dart';

class AgendaMiddleware extends MiddlewareClass<AppState> {
  final AgendaRepository _repository;

  AgendaMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final user = store.state.user();
    if (user == null) return;

    if (action is AgendaRequestAction || action is AgendaRequestReloadAction) {
      final maintenant = action.maintenant as DateTime;
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
