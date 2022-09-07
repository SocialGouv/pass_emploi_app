import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
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
    final loggedIn = store.state.loginState;
    if (loggedIn is LoginSuccessState && action is AgendaRequestAction) {
      final Agenda? agenda;
      if (loggedIn.user.loginMode.isPe()) {
        agenda = await _repository.getAgendaPoleEmploi(loggedIn.user.id, action.maintenant);
      } else {
        agenda = await _repository.getAgendaMissionLocale(loggedIn.user.id, action.maintenant);
      }
      store.dispatch(agenda != null ? AgendaRequestSuccessAction(agenda) : AgendaRequestFailureAction());
    }
  }
}
