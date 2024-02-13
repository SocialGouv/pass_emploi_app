import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
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
      final DateTime maintenant = _getMaintenant(action);
      final agenda = await _repository.getAgendaPoleEmploi(user.id, maintenant);
      store.dispatch(agenda != null ? AgendaRequestSuccessAction(agenda) : AgendaRequestFailureAction());
    }
  }
}

DateTime _getMaintenant(dynamic action) {
  return (action is AgendaRequestAction || action is AgendaRequestReloadAction)
      ? action.maintenant as DateTime
      : DateTime.now();
}
