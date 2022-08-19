import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
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
      final agenda = await _repository.getAgenda(loggedIn.user.id, action.maintenant);
      if (agenda != null) {
        store.dispatch(AgendaRequestSuccessAction(agenda));
      } else {
        // dispatching error
      }
    }
  }
}
