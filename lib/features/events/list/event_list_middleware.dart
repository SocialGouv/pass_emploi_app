import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/animations_collectives_repository.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';
import 'package:redux/redux.dart';

class EventListMiddleware extends MiddlewareClass<AppState> {
  final AnimationsCollectivesRepository _animationsCollectivesRepository;
  final SessionMiloRepository _sessionMiloRepository;

  EventListMiddleware(this._animationsCollectivesRepository, this._sessionMiloRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is EventListRequestAction) {
      store.dispatch(EventListLoadingAction());
      late List<Rendezvous>? animations;
      late List<SessionMilo>? sessions;
      await Future.wait([
        _animationsCollectivesRepository.get(userId, action.maintenant).then((result) => animations = result),
        _sessionMiloRepository.getList(userId).then((result) => sessions = result),
      ]);
      if (animations != null || sessions != null) {
        store.dispatch(EventListSuccessAction(animations ?? [], sessions ?? []));
      } else {
        store.dispatch(EventListFailureAction());
      }
    }
  }
}
